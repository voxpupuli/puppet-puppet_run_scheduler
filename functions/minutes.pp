function puppet_run_scheduler::minutes (
  Puppet_run_scheduler::Run_interval $value,
) {
  $number = Integer($value[0,-2])

  case $value {
    /m$/: { $number }
    /h$/: { $number * 60 }
  }

}
