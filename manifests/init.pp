# puppet_run_scheduler
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include puppet_run_scheduler
class puppet_run_scheduler (
  Integer $run_interval = 30,
  String  $start_time   = '16:00',
  Boolean $splay        = true,
  Integer $splay_limit  = $run_interval,
) {
  $run_interval_minutes = $run_interval

  # Validation
  if ((1440 % $run_interval_minutes) != 0) {
    fail("puppet_run_scheduler::run_interval must be a multiple of 24h")
  }

  $splay_limit_minutes = $splay_limit
  $splay_minutes = fqdn_rand($splay_limit_minutes, 'puppet_run_scheduler')
  $start_hour   = Integer($start_time[0,2])
  $start_min    = Integer($start_time[3,2])

  $adj_start_mins_since_midnight = $start_hour * 60 + $start_min + $splay_minutes

  $adj_start_hour = $adj_start_mins_since_midnight / 60
  $adj_start_min  = $adj_start_mins_since_midnight % 60

  case $facts[os][family] {
    'windows': { contain puppet_run_scheduler::windows }
    default:   { contain puppet_run_scheduler::posix   }
  }

  #service { 'puppet':
  #  enable => false,
  #  ensure => stopped,
  #}

}
