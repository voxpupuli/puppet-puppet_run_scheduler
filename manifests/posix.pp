# puppet_agent_scheduler::posix
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include puppet_agent_scheduler::posix
class puppet_agent_scheduler::posix {
  assert_private()

  #$puppet_agent_scheduler::run_interval_minutes
  #$puppet_agent_scheduler::adj_start_mins_since_midnight
  $start_hour = $puppet_agent_scheduler::adj_start_hour
  $start_min  = $puppet_agent_scheduler::adj_start_min

  notify { 'start min': message => $start_min; }
  notify { 'start hour': message => $start_hour; }


}
