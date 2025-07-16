# puppet_run_scheduler::windows
#
# @summary Private implementation class for Windows OS
#
# @param [String[1]] scheduled_task_user
#   The user to run the Puppet run scheduled task as.
#
# @param [Stdlib::Absolutepath] puppet_executable
#   The fully qualified path to the Puppet executable to run on Windows
#   systems. All of the Puppet command-line arguments appropriate for perfoming
#   a one-time run will be passed to this executable.
#
# @param [Boolean] manage_lastrun_acls
#   Whether or not to manage acl entries on Puppet lastrun files, to work
#   around [PUP-9238](https://tickets.puppetlabs.com/browse/PUP-9238).
#
# @param [Optional[Variant[String[1], Sensitive[String[1]]]]] scheduled_task_password
#   The password for the user to run the Puppet run scheduled task as. Only
#   used if specifying a user other than "system" via `scheduled_task_user`.
#
class puppet_run_scheduler::windows (
  String[1]                                          $scheduled_task_user     = 'system',
  Stdlib::Absolutepath                               $puppet_executable       = $puppet_run_scheduler::windows_puppet_executable,
  Boolean                                            $manage_lastrun_acls     = true,
  Optional[Variant[String[1], Sensitive[String[1]]]] $scheduled_task_password = undef,
) {
  assert_private()

  $interval_mins = $puppet_run_scheduler::interval_mins
  $start_hour    = $puppet_run_scheduler::start_hour
  $start_min     = $puppet_run_scheduler::start_min

  $split_exe = $puppet_executable.split(/[\/\\]/)
  $basename  = $split_exe[-1]
  $dirname   = $split_exe[0,-2].join('\\')

  # If mins is 1440 (24h), then we need to NOT set minutes_interval in the
  # trigger. Daily schedule, no minutes_interval option = run once a day.
  # Otherwise, for more frequently than once daily, we set minutes_interval to
  # a value.
  $trigger = [{
      'schedule'         => 'daily',
      'start_time'       => sprintf('%02d:%02d', $start_hour, $start_min),
    } + ($interval_mins ? {
        1440    => {},
        default => { 'minutes_interval' => $interval_mins },
  })]

  scheduled_task { 'puppet-run-scheduler':
    ensure        => $puppet_run_scheduler::ensure,
    command       => $puppet_executable, # TODO: change this to $basename when scheduled_task supports it
    working_dir   => $dirname,
    arguments     => "agent ${puppet_run_scheduler::agent_flags}",
    enabled       => true,
    user          => $scheduled_task_user,
    password      => $scheduled_task_password,
    before        => Service['puppet'],
    compatibility => 2,
    trigger       => $trigger,
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

      # Since entity names still are localised on Windows, we need to use the
      # unambiguous well-known SIDs [1], replacing 'BUILTIN\Administrators' with
      # 'S-1-5-32-544' as otherwise a non-English installation will fail here.
      # [1] https://learn.microsoft.com/en-us/windows/win32/secauthz/well-known-sids
      acl { $title:
        target                     => $path,
        purge                      => false,
        inherit_parent_permissions => false,
        permissions                => [
          { 'identity' => 'NT AUTHORITY\SYSTEM', 'rights' => ['full'] },
          { 'identity' => 'S-1-5-32-544', 'rights' => ['full'] },
        ],
      }
    }
  }
}
