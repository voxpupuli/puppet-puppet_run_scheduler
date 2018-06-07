# puppet_run_scheduler::windows
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include puppet_run_scheduler::windows
class puppet_run_scheduler::windows {
  assert_private()

  $interval_mins = $puppet_run_scheduler::interval_mins
  $start_hour    = $puppet_run_scheduler::start_hour
  $start_min     = $puppet_run_scheduler::start_min

  scheduled_task { 'Puppet Agent Run':
    ensure    => 'present',
    command   => 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat',
    arguments => 'agent -t',
    enabled   => 'true',
    user      => 'system',
    before    => Service['puppet'],
    trigger   => [{
      'schedule'         => 'daily',
      'start_time'       => sprintf('%02d:%02d', $start_hour, $start_min),
      'minutes_interval' => $interval_mins,
    }],
  }

}
