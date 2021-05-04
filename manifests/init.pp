# puppet_run_scheduler
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example Using a default 30m run interval, you can simply include the class
#   include puppet_run_scheduler
#
# @example Parameters exist that can be used to fine-tune exactly how the runs are scheduled
#   class { 'puppet_run_scheduler':
#     run_interval => '4h',
#     splaylimit   => '1h',
#     start_time   => '16:00',
#   }
#
# @param [Enum['present', 'absent']] ensure
#   Whethor or not to schedule the running of puppet. "absent" only exists to
#   provide clean-up or rollback options in case the class is applied somewhere
#   it shouldn't have been.
#
# @param [Puppet_run_scheduler::Run_interval] run_interval
#   What frequency Puppet should run at. This value cannot be any period; there
#   is an enumerated list of acceptable values.
#   Valid values: 15m, 30m, 1h, 2h, 3h, 4h, 6h, 8h, 12h, 24h
#
# @param [Pattern[/[0-2]\d:\d\d/]] start_time
#   A specific time in the form of HH:MM that a Puppet run should start (
#   subject to the `splaylimit` parameter). This is useful for organizations
#   with long run intervals and specific maintenance windows. For example, 
#   given a `run_interval` of 4h and a `splaylimit` of 30m, administrators can
#   use `start_time` to ensure that Puppet runs occur during the first 30
#   minutes of a known maintenance window.
#
# @param [Puppet_run_scheduler::Run_interval] splaylimit
#   Same format as `run_interval`. How long a period of time to spread runs out
#   over. By default runs will be fully spread out over the entire
#   `run_interval`, but it is possible to have a shorter `splaylimit`.
#
# @param [Stdlib::Absolutepath] posix_puppet_executable
#   The fully qualified path to the Puppet executable to run on Posix systems.
#   All of the Puppet command-line arguments appropriate for perfoming a
#   one-time run will be passed to this executable.
#
# @param [Stdlib::Absolutepath] windows_puppet_executable
#   The fully qualified path to the Puppet executable to run on Windows
#   systems. All of the Puppet command-line arguments appropriate for perfoming
#   a one-time run will be passed to this executable.
#
class puppet_run_scheduler (
  Enum['present', 'absent']          $ensure                    = 'present',
  Puppet_run_scheduler::Run_interval $run_interval              = '30m',
  Pattern[/[0-2]\d:\d\d/]            $start_time                = '00:00',
  Puppet_run_scheduler::Run_interval $splaylimit                = $run_interval,
  Stdlib::Absolutepath               $posix_puppet_executable   = '/opt/puppetlabs/bin/puppet',
  Stdlib::Absolutepath               $windows_puppet_executable = 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat',
) {
  $interval_mins = puppet_run_scheduler::minutes($run_interval)
  $splaylimit_mins = puppet_run_scheduler::minutes($splaylimit)

  $splay_mins = fqdn_rand($splaylimit_mins, 'puppet_run_scheduler')
  $input_start_hour = Integer($start_time[0,2])
  $input_start_min  = Integer($start_time[3,2])

  $splayed_start_epoch_mins = $input_start_hour * 60 + $input_start_min + $splay_mins
  $first_start_epoch_mins   = $splayed_start_epoch_mins % $interval_mins

  $runs_per_day = 1440 / $interval_mins
  $start_hour = $first_start_epoch_mins / 60
  $start_min  = $first_start_epoch_mins % 60

  $agent_flags = '--onetime --no-daemonize --splay --splaylimit=60s'

  case $facts[os][family] {
    'windows': { contain puppet_run_scheduler::windows }
    default:   { contain puppet_run_scheduler::posix }
  }

  if ($ensure == 'present') {
    $service_enable = false
    $service_ensure = stopped
  } else {
    $service_enable = true
    $service_ensure = running
  }

  service { 'puppet':
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
