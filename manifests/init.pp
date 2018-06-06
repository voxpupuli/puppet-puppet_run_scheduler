# puppet_agent_scheduler
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include puppet_agent_scheduler
class puppet_agent_scheduler (
  Integer $run_interval = 30,
  String  $start_time   = '00:00',
  Boolean $splay        = true,
  Integer $splay_limit  = $run_interval,
) {

  $run_interval_minutes = $run_interval
  $splay_limit_minutes = $splay_limit
  $splay_minutes = fqdn_rand($splay_limit_minutes, 'puppet_agent_scheduler')

  # Validation
  if ((1440 % $run_interval_minutes) != 0) {
    fail("puppet_agent_scheduler::run_interval must be a multiple of 24h")
  }

  case $facts[os][family] {
    'windows': { contain puppet_agent_scheduler::windows }
    default:   { contain puppet_agent_scheduler::posix   }
  }

  #service { 'puppet':
  #  enable => false,
  #  ensure => stopped,
  #}

}
