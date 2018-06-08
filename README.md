# puppet\_run\_scheduler

Configure and distribute Puppet run frequency using Cron (Posix) and Scheduled Tasks (Windows).

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with puppet\_run\_scheduler](#setup)
    * [What puppet\_run\_scheduler affects](#what-puppet_run_scheduler-affects)
3. [Usage - Configuration options and additional functionality](#usage)

## Description

By default, Puppet runs once every 30 minutes on client systems, with a service and timer controlling the frequency of runs. For massive installations of Puppet the imprecise timing results in "waves" of load being seen on the Puppet servers, as tens of thousands of systems rarely distribute themselves perfectly throughout the run interval.

The puppet\_run\_scheduler module replaces the running service method of scheduling and replaces it with precise distribution of load using system schedulers, Cron (Posix) and Scheduled Tasks (Windows). This eliminates "waves" of load in massive installations, perfectly distributing activity through the run interval period.

## Setup

### What puppet\_run\_scheduler affects

The puppet service will be disabled when puppet\_run\_scheduler is implemented on all platforms.

On Windows, puppet\_run\_scheduler will install a Scheduled Task called "puppet-run-scheduler".

On Linux/Unix, puppet\_run\_scheduler will install a puppet-run-scheduler cron job under the root user.

## Usage

Using a default 30m run interval, you can simply include the class.

```puppet
include puppet_run_scheduler
```

Parameters exist that can be used to fine-tune exactly how the runs are scheduled.

```puppet
class { 'puppet_run_scheduler':
  run_interval => '4h',
  splaylimit   => '1h',
  start_time   => '16:00',
}
```

### Parameters

Parameters on the puppet\_run\_scheduler class can be set when the class is declared resource-style, or else specified in Hiera.

#### ensure

_Default: present_

Supports "present" or "absent". Note that "present" is the default, and "absent" only exists to provide clean-up or rollback options in case the class is applied somewhere it shouldn't have been.

#### run\_interval

_Default: "30m"_

What frequency Puppet should run at. This value cannot be any period; there is an enumerated list of acceptable values.

Valid values: 15m, 30m, 1h, 2h, 3h, 4h, 6h, 8h, 12h, 24h

#### splaylimit

_Default: $run\_interval_

Same format as run\_interval. How long a period of time to spread runs out over. By default runs will be fully spread out over the entire run\_interval, but it is possible to have a shorter splaylimit.

#### start\_time

_Default: "00:00"_

A specific time in the form of HH:MM that a Puppet run should start (subject to the splaylimit parameter). This is useful for organizations with long run intervals and specific maintenance windows. For example, given a run\_interval of 4h and a splaylimit of 30m, administrators can use start\_time to ensure that Puppet runs occur during the first 30 minutes of a known maintenance window.

### Data Parameters

Parameters in private classes which can be set using Hiera to further adjust behavior. Because private classes cannot be declared resource-style, the only way to use these parameters is to set them in Hiera.

#### `puppet_run_scheduler::windows::scheduled_task_user`

_Default: "system"_

The user to run the Puppet run scheduled task as.

#### `puppet_run_scheduler::windows::scheduled_task_password`

_Default: undef_

The password for the user to run the Puppet run scheduled task as. Only used if specifying a user other than "system".

## Known Issues

On Windows, when running from a Scheduled Task, Puppet creates cache files that are not readable by "Everyone", only SYSTEM. This has the effect of making manual `puppet agent -t` runs return a lot of red text in the shell. The last line of red text even suggests that Puppet was unable to submit a report. This isn't true though; Puppet DOES submit a report.

A fix will need to discover why the cache files are created with the permissions that they are, and implement some change to ensure the files are readable by at least the local administrators group.
