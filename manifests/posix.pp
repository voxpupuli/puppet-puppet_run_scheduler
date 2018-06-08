# puppet_run_scheduler::posix
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include puppet_run_scheduler::posix
class puppet_run_scheduler::posix {
  assert_private()

  $interval_mins = $puppet_run_scheduler::interval_mins
  $runs_per_day  = $puppet_run_scheduler::runs_per_day
  $start_hour    = $puppet_run_scheduler::start_hour
  $start_min     = $puppet_run_scheduler::start_min

  $hours = $runs_per_day.map |$n| {
    $epoch_mins = ($start_hour * 60) + $start_min + ($n * $interval_mins)
    $epoch_mins / 60
  }.unique()

  $mins = $runs_per_day.map |$n| {
    $epoch_mins = $start_min + ($n * $interval_mins)
    $epoch_mins % 60
  }.unique()

  cron { 'puppet-run-scheduler':
    ensure  => $puppet_run_scheduler::ensure,
    command => "/opt/puppetlabs/bin/puppet agent ${puppet_run_scheduler::agent_flags} >/dev/null 2>&1",
    user    => 'root',
    hour    => $hours,
    minute  => $mins,
    before  => Service['puppet'],
  }

}
