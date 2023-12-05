class io_metricbeat (
  $ensure                    = lookup('ensure', undef, undef, 'present'),
  $psft_runtime_user_name    = lookup('psft_runtime_user_name', undef, undef, 'psadm2'),
  $psft_runtime_group_name   = lookup('psft_runtime_group_name', undef, undef, 'oinstall'),
  $monitor_location          = undef,
  $service_name              = lookup('io_metricbeat::service_name', undef, undef, 'peoplesoft'),
  $check_interval            = lookup('io_metricbeat::check_interval', undef, undef, '300s'),
  $port                      = lookup('io_metricbeat::port', undef, undef, '8443'),
  $fqdn                      = lookup('io_metricbeat::fqdn', undef, undef, $::fqdn),
  $host                      = lookup('io_metricbeat::host', undef, undef, $::hostname),
  $user                      = lookup('io_metricbeat::user', undef, undef, 'system'),
  $pwd                       = lookup('io_metricbeat::pwd', undef, undef, ''),
  $ssl_verify                = lookup('io_metricbeat::ssl_verify', undef, undef, true),
  $trust_ca                  = lookup('io_metricbeat::trust_ca', undef, undef, true),
  $ca_file                   = lookup('io_metricbeat::ca_file', undef, undef, '/usr/share/metricbeat/trust.crt'),
  $health                    = lookup('io_metricbeat::health', undef, undef, true),
  $health_fields             = lookup('io_metricbeat::health_fields', undef, undef, 'name,state,activationTime'),
  $jvm                       = lookup('io_metricbeat::jvm', undef, undef, true),
  $jvm_fields                = lookup('io_metricbeat::jvm_fields', undef, undef, 'heapSizeCurrent,heapFreeCurrent,heapFreePercent,heapSizeMax,name,type,processCpuLoad'),
  $pia                       = lookup('io_metricbeat::pia', undef, undef, true),
  $pia_fields                = lookup('io_metricbeat::pia_fields', undef, undef, 'openSessionsCurrentCount,openSessionsHighCount')
) {
  if ($health) {
    contain ::io_metricbeat::health
  }
  if ($jvm) {
    contain ::io_metricbeat::jvm
  }
  if ($pia) {
    contain ::io_metricbeat::pia
  }
}
