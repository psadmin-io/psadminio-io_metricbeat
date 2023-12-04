# io_metricbeat

The `io_metricbeat` Puppet module will create Heartbeat monitors for web servers, app servers, and hosts. It can be run with the DPK to automatically create monitors for Heartbeat to consume. 

## Table of Contents

- [io\_metricbeat](#io_metricbeat)
  - [Table of Contents](#table-of-contents)
  - [Setup](#setup)
    - [What io\_metricbeat affects](#what-io_metricbeat-affects)
  - [Reference](#reference)

## Setup

1. Clone the repository or add it as a submodule to the DPK.

    ```bash
    $ cd <DPK_LOCATION>
    $ git submodule add https://github.com/psadmin-io/io_metricbeat.git modules/io_metricbeat
    ```
2. Add the required `io_metricbeat::vars` (See the [Reference](#reference) section.)
3. Run the module to test

    ```bash
    $ puppet apply --confdir <DPK_LOCATION> -e "contain ::io_metricbeat"
    ```

4. (Optional) Include `io_metricbeat` as pat of your DPK build by added it to your DPK role.

    ```puppet
    # pt_tools_midtier.pp
    if $ensure == present {
      contain ::pt_profile::pt_tools_preboot_config
      contain ::pt_profile::pt_domain_boot
      contain ::pt_profile::pt_tools_postboot_config
      contain ::pt_profile::pt_password
      contain ::io_metricbeat
      
      Class['::pt_profile::pt_system'] ->
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

The module will not modify PeopleSoft domains. It only creates external files to be used with Metricbeat for monitoring PeopleSoft WebLogic domains. 

## Reference

Configuration options:

* Service Name: used by Elasticsearch/Opensearch Observability to group different monitors into a application.
* Monitor Location: Where `io_metricbeat` will write the monitor files.
* Check Interval: How often to run the monitor (default is `300s`)
* Web Port: Specify HTTP port for the web monitor (default is `8000`)
* Fully Qualified Domain Name: The FQDN to use for connecting to the Weblogic Domain (default is `::fqdn` fact)
* Hostname: Use for added fields in the Metricbeat data (default is `::hostname` fact)
* User: The Weblogic user to connect to the `/management` API
* Password: The Weblogic user password to connect to the `/management` API
* Health (boolean): Enable creation of the Health monitor (default is `true`)
* Health Fields: the fields to select from the `/serverRuntime` API (default is `name,state,activationTime`)
* JVM (boolean): Enable the creation of the JVM monitor (default is `true`)
* JVM Fields: the fields to select from the `serverRuntime/JVMRuntime` API (default is `heapSizeCurrent,heapFreeCurrent,heapFreePercent,heapSizeMax,name,type`)
* PIA (boolean): Enable the creation of the PIA monitor (default is `true`)
* PIA Fields: the fields to select from the `serverRuntime/applicationRuntimes/peoplesoft/componentRuntimes/PIA_` API (default is `openSessionsCurrentCount,openSessionsHighCount`)

Add this configuration to your `psft_customizations.yaml` file to enable `io_metricbeat`.

```yaml
---
io_metricbeat::service_name:      "%{hiera('db_name')}"
io_metricbeat::monitor_location:  '/psoft/share/metricbeat/'
io_metricbeat::pwd:               "${WL_ADMIN_PWD}" # This can reference a keystore value
io_metricbeat::port:              "%{hiera('pia_http_port')}"
```
