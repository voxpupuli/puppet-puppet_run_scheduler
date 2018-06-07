class { 'puppet_run_scheduler':
  run_interval => '4h',
  splay_limit  => '1h',
  start_time   => '16:00',
}
