# puppet_run_scheduler::posix
#
# @param [Stdlib::Absolutepath] puppet_executable
#   The fully qualified path to the Puppet executable to run on Posix systems.
#   All of the Puppet command-line arguments appropriate for perfoming a
#   one-time run will be passed to this executable.
#
class puppet_run_scheduler::posix (
  Stdlib::Absolutepath $puppet_executable = $puppet_run_scheduler::posix_puppet_executable,
) {
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
    command => "${puppet_executable} agent ${puppet_run_scheduler::agent_flags} >/dev/null 2>&1",
    user    => 'root',
    hour    => $hours,
    minute  => $mins,
    before  => Service['puppet'],
  }
}
