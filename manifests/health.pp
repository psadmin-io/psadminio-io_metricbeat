class io_wl_stats::health (
  $ensure                    = $io_wl_stats::ensure,
  $psft_runtime_user_name    = $io_wl_stats::psft_runtime_user_name,
  $psft_runtime_group_name   = $io_wl_stats::psft_runtime_group_name,
  $monitor_location          = $io_wl_stats::monitor_location,
  $service_name              = $io_wl_stats::service_name,
  $check_interval            = $io_wl_stats::check_interval,
  $host                      = $io_wl_stats::host,
  $port                      = $io_wl_stats::port,
  $user                      = $io_wl_stats::user,
  $pwd                       = $io_wl_stats::port,
  $health_fields             = $io_wl_stats::health_fields
) inherits io_wl_stats {
  notify { "Create Metricbeat monitors for Health Status of ${service_name}-${host}": }

  file { "${monitor_location}/health-${service_name}-${host}.yml" :
    ensure  => file,
    content => template('io_wl_stats/health.yml.erb'),
    owner   => $psft_runtime_user_name,
    group   => $psft_runtime_group_name,
    mode    => '0644',
  }
}
