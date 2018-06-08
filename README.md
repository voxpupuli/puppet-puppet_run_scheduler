# puppet\_run\_scheduler

Configure and distribute Puppet run frequency using Cron (Posix) and Scheduled Tasks (Windows).

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with puppet\_run\_scheduler](#setup)
    * [What puppet\_run\_scheduler affects](#what-puppet_run_scheduler-affects)
    * [Beginning with puppet\_run\_scheduler](#beginning-with-puppet_run_scheduler)
3. [Usage - Configuration options and additional functionality](#usage)

## Description

By default, Puppet runs once every 30 minutes on client systems, with a service and timer controlling the frequency of runs. For massive installations of Puppet the imprecise timing results in "waves" of load being seen on the Puppet servers, as tens of thousands of systems rarely distribute themselves perfectly throughout the run interval.

The puppet\_run\_scheduler module replaces the running service method of scheduling and replaces it with precise distribution of load using system schedulers, Cron (Posix) and Scheduled Tasks (Windows). This eliminates "waves" of load in massive installations, perfectly distributing activity through the run interval period.

## Setup

### What puppet\_run\_scheduler affects **OPTIONAL**

The `puppet` service will be disabled when puppet\_run\_scheduler is implemented on all platforms.

On Windows, puppet\_run\_scheduler will install a Scheduled Task called "puppet-run-scheduler".

On Linux/Unix, puppet\_run\_scheduler will install a puppet-run-scheduler cron job under the root user.

### Beginning with puppet\_run\_scheduler

Using a default 30m run interval, you can simply include the class.

```puppet
include puppet_run_scheduler
```

Parameters exist that can be used to fine-tune exactly how the runs are scheduled.

```puppet
class { 'puppet_run_scheduler':
  run_interval => '4h',
  splay_limit  => '1h',
  start_time   => '16:00',
}
```

## Usage

See above for basic usage.

### Parameters

#### ensure

Supports "present" or "absent". Note that "present" is the default, and "absent" only exists to provide clean-up or rollback options in case the class is applied somewhere it shouldn't have been.

#### run\_interval

What frequency Puppet should run at. There are an enumerated list of acceptable values ranging from 15m to 24h.

#### splaylimit

Same format as run\_interval. How long a period of time to spread runs out over. By default runs will be fully spread out over the entire run\_interval, but it is possible to have a shorter splaylimit.

#### start\_time

A specific time in the form of HH:MM that a Puppet run should start (subject to the splaylimit parameter). This is useful for organizations with long run intervals and specific maintenance windows. For example, given a run\_interval of 4h and a splaylimit of 30m, administrators can use start\_time to ensure that Puppet runs occur at the beginning of a known maintenance window.
