class io_wl_stats (
  $ensure                    = lookup('ensure', undef, undef, 'present'),
  $psft_runtime_user_name    = lookup('psft_runtime_user_name', undef, undef, 'psadm2'),
  $psft_runtime_group_name   = lookup('psft_runtime_group_name', undef, undef, 'oinstall'),
  $pia_domain_list           = lookup('pia_domain_list', undef, undef, ''),
  $hostname                  = $::hostname,
  $fqdn                      = $::fqdn,
  $monitor_location          = undef,
  $service_name              = lookup('io_wl_stats::service_name', undef, undef, 'peoplesoft'),
  $check_interval            = lookup('io_wl_stats::check_interval', undef, undef, '300s'),
  $port                      = lookup('io_wl_stats::port', undef, undef, '8000'),
  $host                      = lookup('io_wl_stats::host', undef, undef, ''),
  $user                      = lookup('io_wl_stats::user', undef, undef, ''),
  $pwd                       = lookup('io_wl_stats::pwd', undef, undef, ''),
  $health                    = lookup('io_wl_stats::health', undef, undef, true),
  $health_fields             = lookup('io_wl_stats::health_fields', undef, undef, 'name,state,activationTime'),
  $jvm                       = lookup('io_wl_stats::jvm', undef, undef, true),
  $pia                       = lookup('io_wl_stats::pia', undef, undef, true)
) {
  if ($health) {
    contain ::io_wl_stats::health
  }
  # if ($jvm) {
  #   contain ::io_wl_stats::jvm
  # }
  # if ($pia) {
  #   contain ::io_wl_stats::pia
  # }
}
