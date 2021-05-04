# puppet\_run\_scheduler

![](https://img.shields.io/puppetforge/pdk-version/reidmv/puppet_run_scheduler.svg?style=popout)
![](https://img.shields.io/puppetforge/v/reidmv/puppet_run_scheduler.svg?style=popout)
![](https://img.shields.io/puppetforge/dt/reidmv/puppet_run_scheduler.svg?style=popout)
[![Build Status](https://github.com/reidmv/reidmv-puppet_run_scheduler/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/reidmv/reidmv-puppet_run_scheduler/actions/workflows/ci.yml)

Configure and distribute Puppet run frequency using Cron (Posix) and Scheduled Tasks (Windows).

- [Description](#description)
- [Setup](#setup)
  - [What puppet\_run\_scheduler affects](#what-puppet_run_scheduler-affects)
- [Reference](#reference)
- [Known Issues](#known-issues)

## Description

By default, Puppet runs once every 30 minutes on client systems, with a service and timer controlling the frequency of runs. For massive installations of Puppet the imprecise timing results in "waves" of load being seen on the Puppet servers, as tens of thousands of systems rarely distribute themselves perfectly throughout the run interval.

The puppet\_run\_scheduler module replaces the running service method of scheduling and replaces it with precise distribution of load using system schedulers, Cron (Posix) and Scheduled Tasks (Windows). This eliminates "waves" of load in massive installations, perfectly distributing activity through the run interval period.

## Setup

### What puppet\_run\_scheduler affects

The puppet service will be disabled when puppet\_run\_scheduler is implemented on all platforms.

On Windows, puppet\_run\_scheduler will install a Scheduled Task called "puppet-run-scheduler".

On Linux/Unix, puppet\_run\_scheduler will install a puppet-run-scheduler cron job under the root user.

## Reference

This module is documented via `pdk bundle exec puppet strings generate --format markdown`. Please see [REFERENCE.md](REFERENCE.md) for more info.


## Known Issues

See https://tickets.puppetlabs.com/browse/PUP-9238.

On Windows, when running from a Scheduled Task, Puppet creates cache files that are not readable by "Everyone", only SYSTEM. This has the effect of making manual `puppet agent -t` runs return a lot of red text in the shell. The last line of red text even suggests that Puppet was unable to submit a report. This isn't true though; Puppet DOES submit a report.

A workaround exists in the module to avoid this by explicitly ensuring minimal ACEs exist on those files.
