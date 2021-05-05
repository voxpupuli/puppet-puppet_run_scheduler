# A list of permissible run_interval settings
type Puppet_run_scheduler::Run_interval = Enum[
  '15m',
  '30m',
  '1h',
  '2h',
  '3h',
  '4h',
  '6h',
  '8h',
  '12h',
  '24h',
]
