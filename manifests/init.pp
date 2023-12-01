class io_metricbeat (
  $ensure                    = lookup('ensure', undef, undef, 'present'),
  $psft_runtime_user_name    = lookup('psft_runtime_user_name', undef, undef, 'psadm2'),
  $psft_runtime_group_name   = lookup('psft_runtime_group_name', undef, undef, 'oinstall'),
  $monitor_location          = undef,
  $service_name              = lookup('io_metricbeat::service_name', undef, undef, 'peoplesoft'),
  $check_interval            = lookup('io_metricbeat::check_interval', undef, undef, '300s'),
  $port                      = lookup('io_metricbeat::port', undef, undef, '8000'),
  $fqdn                      = lookup('io_metricbeat::fqdn', undef, undef, $::fqdn),
  $host                      = lookup('io_metricbeat::host', undef, undef, $::hostname),
  $user                      = lookup('io_metricbeat::user', undef, undef, 'system'),
  $pwd                       = lookup('io_metricbeat::pwd', undef, undef, ''),
  $health                    = lookup('io_metricbeat::health', undef, undef, true),
  $health_fields             = lookup('io_metricbeat::health_fields', undef, undef, 'name,state,activationTime'),
  $jvm                       = lookup('io_metricbeat::jvm', undef, undef, true),
  $pia                       = lookup('io_metricbeat::pia', undef, undef, true)
) {
  if ($health) {
    contain ::io_metricbeat::health
  }
  # if ($jvm) {
  #   contain ::io_metricbeat::jvm
  # }
  # if ($pia) {
  #   contain ::io_metricbeat::pia
  # }
}
