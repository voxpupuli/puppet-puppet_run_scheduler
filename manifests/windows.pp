# puppet_run_scheduler::windows
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include puppet_run_scheduler::windows
class puppet_run_scheduler::windows (
  String                            $scheduled_task_user     = 'system',
  Variant[Undef, String, Sensitive] $scheduled_task_password = undef,
) {
  assert_private()

  $interval_mins = $puppet_run_scheduler::interval_mins
  $start_hour    = $puppet_run_scheduler::start_hour
  $start_min     = $puppet_run_scheduler::start_min

  scheduled_task { 'puppet-run-scheduler':
    ensure    => $puppet_run_scheduler::ensure,
    command   => 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat',
    arguments => "agent ${puppet_run_scheduler::agent_flags}",
    enabled   => true,
    user      => $scheduled_task_user,
    password  => $scheduled_task_password,
    before    => Service['puppet'],
    trigger   => [{
      'schedule'         => 'daily',
      'start_time'       => sprintf('%02d:%02d', $start_hour, $start_min),
      'minutes_interval' => $interval_mins,
    }],
  }

}
