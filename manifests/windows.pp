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
  String[1]                         $puppet_executable       = 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat',
  Boolean                           $manage_lastrun_acls     = true,
) {
  assert_private()

  $interval_mins = $puppet_run_scheduler::interval_mins
  $start_hour    = $puppet_run_scheduler::start_hour
  $start_min     = $puppet_run_scheduler::start_min

  scheduled_task { 'puppet-run-scheduler':
    ensure        => $puppet_run_scheduler::ensure,
    command       => $puppet_executable,
    arguments     => "agent ${puppet_run_scheduler::agent_flags}",
    enabled       => true,
    user          => $scheduled_task_user,
    password      => $scheduled_task_password,
    before        => Service['puppet'],
    compatibility => 2,
    trigger              => [{
      'schedule'         => 'daily',
      'start_time'       => sprintf('%02d:%02d', $start_hour, $start_min),
      'minutes_interval' => $interval_mins,
    }],
  }

  # https://tickets.puppetlabs.com/browse/PUP-9238
  # On Windows, the lastrun files are currently not created with appropriate
  # directory inherited acls. Lastrun files created when Puppet is run from a
  # scheduled task will have improper ACLs that will prevent Puppet from
  # finishing a manually invoked run correctly. Therefore, ensure during the
  # Puppet run that ACLs on these files are set correctly.
  if $manage_lastrun_acls {
    $statedir = 'C:/ProgramData/PuppetLabs/puppet/cache/state'
    $lastrun_files = {
      'puppet-lastrunfile'   => "${statedir}/last_run_summary.yaml",
      'puppet-lastrunreport' => "${statedir}/last_run_report.yaml",
    }

    $lastrun_files.each |$title, $path| {
      file { $title:
        ensure => file,
        path   => $path,
      }

      acl { $title:
        target                     => $path,
        purge                      => false,
        inherit_parent_permissions => false,
        permissions                => [
          {'identity' => 'BUILTIN\Administrators', 'rights' => ['full']},
          {'identity' => 'NT AUTHORITY\SYSTEM', 'rights' => ['full']},
        ],
      }
    }
  }

}
