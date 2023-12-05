# io_metricbeat

The `io_metricbeat` Puppet module will create Metricbeat module files to monitor PeopleSoft Weblogic domains. Running this module with the DPK will create files to track general health of the domain, the JVM status and health, and the session counts for the PIA application. 

## Table of Contents

- [io\_metricbeat](#io_metricbeat)
  - [Table of Contents](#table-of-contents)
  - [Setup](#setup)
    - [What io\_metricbeat affects](#what-io_metricbeat-affects)
  - [Reference](#reference)
    - [HTTPS Verification](#https-verification)

## Setup

1. Clone the repository or add it as a submodule to the DPK.

    ```bash
    $ cd <DPK_LOCATION>
    $ git submodule add https://github.com/psadmin-io/psadminio-io_metricbeat.git modules/io_metricbeat
    ```
2. Add the required `io_metricbeat::vars` (See the [Reference](#reference) section.)
3. Run the module to test

    ```bash
    $ puppet apply --confdir <DPK_LOCATION> -e "contain ::io_metricbeat"
    ```

4. (Optional) Include `io_metricbeat` as part of your DPK build by adding it to your DPK role.

    ```puppet
    # pt_tools_midtier.pp
    if $ensure == present {
      contain ::pt_profile::pt_tools_preboot_config
      contain ::pt_profile::pt_domain_boot
      contain ::pt_profile::pt_tools_postboot_config
      contain ::pt_profile::pt_password
      contain ::io_metricbeat
      
      Class['::pt_profile::pt_<user>'] ->
      Class['::pt_profile::pt_tools_deployment'] ->
      Class['::pt_profile::pt_psft_environment'] ->
      Class['::pt_profile::pt_appserver'] ->
      Class['::pt_profile::pt_prcs'] ->
      Class['::pt_profile::pt_pia'] ->
      Class['::pt_profile::pt_tools_preboot_config'] ->
      Class['::pt_profile::pt_domain_boot'] ->
      Class['::pt_profile::pt_tools_postboot_config'] ->
      Class['::io_metricbeat']
    }
    ```

### What io_metricbeat affects 

The module will not modify PeopleSoft domains. It only creates `modules.d/*.yml` files to be used with Metricbeat for monitoring PeopleSoft WebLogic domains. 

## Reference

Configuration options:

* Service Name: used by Elasticsearch/Opensearch Observability to group different monitors into a application.
* Monitor Location: Where `io_metricbeat` will write the monitor files.
* Check Interval: How often to run the monitor (default is `300s`)
* Web Port: Specify HTTPS port for the web monitor (default is `8443`). `https://`` is defaulted in the template files.
* Fully Qualified Domain Name: The FQDN to use for connecting to the Weblogic Domain (default is `::fqdn` fact)
* Hostname: Use for added fields in the Metricbeat data (default is `::hostname` fact)
* User: The Weblogic user to connect to the `/management` API
* Password: The Weblogic user password to connect to the `/management` API
* SSL Verify (boolean): SSL Certificate Validation (default is `true`). Change to `false` if you want to skip SSL Certificate Validation.
* Trust CA (boolean): The monitor files will include a Certificate Authority file to verify HTTPS connections (default `true`
* CA File: The Certificate Authority file to use for HTTPS validations (default is `/usr/share/metricbeat/trust.crt`)
* Health (boolean): Enable creation of the Health monitor (default is `true`)
* Health Fields: the fields to select from the `/serverRuntime` API (default is `name,state,activationTime`)
* JVM (boolean): Enable the creation of the JVM monitor (default is `true`)
* JVM Fields: the fields to select from the `serverRuntime/JVMRuntime` API (default is `heapSizeCurrent,heapFreeCurrent,heapFreePercent,heapSizeMax,name,type`)
* PIA (boolean): Enable the creation of the PIA monitor (default is `true`)
* PIA Fields: the fields to select from the `serverRuntime/applicationRuntimes/peoplesoft/componentRuntimes/PIA_` API (default is `openSessionsCurrentCount,openSessionsHighCount`)

This is the minimal configuration to add to `psft_customizations.yaml` to enable `io_metricbeat`. This will create monitor files for Metricbeat.

```yaml
---
io_metricbeat::service_name:      "%{hiera('db_name')}"
io_metricbeat::monitor_location:  '/psoft/share/metricbeat/'
io_metricbeat::pwd:               "%{hiera('webserver_admin_user_pwd')}" 
# This can reference a metricbeat keystore value like this: "${WL_ADMIN_PWD}"
io_metricbeat::port:              "%{hiera('pia_https_port')}"
io_metricbeat::ssl_verify:        false
```

Here are 3 sample files that are created for Metricbeat:

`modules.d/health-hrdev-hostname.yml`

```yaml
- module: http
  metricsets:
    - json
  period: '300s'
  hosts: ["https://<fqdn>:<port>/management/weblogic/latest/serverRuntime?fields=name,state,activationTime&links=none"]
  ssl.verification_mode: 'none'
  namespace: "weblogic"
  method: "GET"
  username: "<user>"
  password: "${WL_ADMIN}"
  service:
    name: hrdev
  fields:
    hostname: hostname
    id: weblogic-hrdev-hostname
```

`modules.d/jvm-hrdev-hostname.yml`

```yaml
- module: http
  metricsets:
    - json
  period: '300s'
  hosts: ["http://<fqdn>:<port>/management/weblogic/latest/serverRuntime/JVMRuntime?fields=heapSizeCurrent,heapFreeCurrent,heapFreePercent,heapSizeMax,name,type&links=none"]
  ssl.verification_mode: 'none'
  namespace: "jvm"
  method: "GET"
  username: "<user>"
  password: "${WL_ADMIN}"
  service:
    name: hrdev
  fields:
    hostname: hostname
    id: weblogic-hrdev-hostname
```

`modules.d/pia-hrdev-hostname.yml`

```yaml
- module: http
  metricsets:
    - json
  period: '300s'
  hosts: ["http://<fqdn>:<port>/management/weblogic/latest/serverRuntime/applicationRuntimes/peoplesoft/componentRuntimes/PIA_?fields=openSessionsCurrentCount,openSessionsHighCount&links=none"]
  ssl.verification_mode: 'none'
  namespace: "pia"
  method: "GET"
  username: "<user>"
  password: "${WL_ADMIN}"
  service:
    name: hrdev
  fields:
    hostname: hostname
    id: weblogic-hrdev-hostname
```

### HTTPS Verification

If you have a self-signed or specific CA file you want to use for verifying HTTPS connections, you can specify that file in configuration. The default is `/usr/share/metricbeat/trust.crt` to be used with the `docker.elastic.co/beats/metricbeat-oss:7.12.1` container image.

```yaml
io_metricbeat::ca_file:              '/psoft/share/ca/self-signed-trust.crt'
```

This value will be added to the monitor files like this:

```yaml
  hosts: ["http://<fqdn>:<port>/management/weblogic/latest/serverRuntime/applicationRuntimes/peoplesoft/componentRuntimes/PIA_?fields=openSessionsCurrentCount,openSessionsHighCount&links=none"]
  ssl.certificate_authorities: ['/psoft/share/ca/self-signed-trust.crt']
```

You can also disable HTTP Verification by using the flag `ssl_verify`.

```yaml
io_metricbeat::ssl_verify:        false
```

This will set `ssl.verification_mode: 'none'` in your monitor files.