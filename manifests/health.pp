class io_metricbeat::health (
  $ensure                    = $io_metricbeat::ensure,
  $psft_runtime_user_name    = $io_metricbeat::psft_runtime_user_name,
  $psft_runtime_group_name   = $io_metricbeat::psft_runtime_group_name,
  $monitor_location          = $io_metricbeat::monitor_location,
  $service_name              = $io_metricbeat::service_name,
  $check_interval            = $io_metricbeat::check_interval,
  $host                      = $io_metricbeat::host,
  $port                      = $io_metricbeat::port,
  $user                      = $io_metricbeat::user,
  $pwd                       = $io_metricbeat::port,
  $health_fields             = $io_metricbeat::health_fields
) inherits io_metricbeat {
  notify { "Create Metricbeat monitors for Health Status of ${service_name}-${host}": }

  file { "${monitor_location}/health-${service_name}-${host}.yml" :
    ensure  => file,
    content => template('io_metricbeat/health.yml.erb'),
    owner   => $psft_runtime_user_name,
    group   => $psft_runtime_group_name,
    mode    => '0644',
  }
}
