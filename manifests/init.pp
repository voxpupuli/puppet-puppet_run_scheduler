# puppet_run_scheduler
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include puppet_run_scheduler
class puppet_run_scheduler (
  Puppet_run_scheduler::Run_interval $run_interval = '30m',
  Pattern[/[0-2]\d:\d\d/]            $start_time   = '00:00',
  Boolean                            $splay        = true,
  Puppet_run_scheduler::Run_interval $splay_limit  = '30m',
) {
  $interval_mins = puppet_run_scheduler::minutes($run_interval)
  $splay_limit_mins = puppet_run_scheduler::minutes($splay_limit)

  $splay_mins = fqdn_rand($splay_limit_mins, 'puppet_run_scheduler')
  $input_start_hour = Integer($start_time[0,2])
  $input_start_min  = Integer($start_time[3,2])

  $splayed_start_epoch_mins = $input_start_hour * 60 + $input_start_min + $splay_mins
  $first_start_epoch_mins   = $splayed_start_epoch_mins % $interval_mins

  $runs_per_day = 1440 / $interval_mins
  $start_hour = $first_start_epoch_mins / 60
  $start_min  = $first_start_epoch_mins % 60

  case $facts[os][family] {
    'windows': { contain puppet_run_scheduler::windows }
    default:   { contain puppet_run_scheduler::posix   }
  }

  service { 'puppet':
    enable => false,
    ensure => stopped,
  }

}
