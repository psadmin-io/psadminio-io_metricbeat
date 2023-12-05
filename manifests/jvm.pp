class io_metricbeat::jvm (
  $ensure                    = $io_metricbeat::ensure,
  $psft_runtime_user_name    = $io_metricbeat::psft_runtime_user_name,
  $psft_runtime_group_name   = $io_metricbeat::psft_runtime_group_name,
  $monitor_location          = $io_metricbeat::monitor_location,
  $service_name              = $io_metricbeat::service_name,
  $check_interval            = $io_metricbeat::check_interval,
  $fqdn                      = $io_metricbeat::fqdn,
  $host                      = $io_metricbeat::host,
  $port                      = $io_metricbeat::port,
  $user                      = $io_metricbeat::user,
  $pwd                       = $io_metricbeat::pwd,
  $ssl_verify                = $io_metricbeat::ssl_verify,
  $trust_ca                  = $io_metricbeat::trust_ca,
  $ca_file                   = $io_metricbeat::ca_file,
  $jvm_fields                = $io_metricbeat::jvm_fields
) inherits io_metricbeat {
  notify { "Create Metricbeat monitors for JVM of ${service_name}-${host}": }

  file { "${monitor_location}/jvm-${service_name}-${host}.yml" :
    ensure  => file,
    content => template('io_metricbeat/jvm.yml.erb'),
    owner   => $psft_runtime_user_name,
    group   => $psft_runtime_group_name,
    mode    => '0644',
  }
}
