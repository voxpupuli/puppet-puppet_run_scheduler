# Changelog

All notable changes to this project will be documented in this file.

## Release 1.0.0

**Features**

* Add puppet\_executable parameters to puppet\_run\_scheduler class, for easier inclusion and use in profiles.

**Improvements**

* Ensure basic unit tests run to completion

**Bug fixes**

* Use an absolute path for `command` in the scheduled\_task resource on Windows. This is necessary to pass the type parameter validation checks.

## Release 0.4.2

Update module dependency metadata to indicate that the newest versions of required modules puppetlabs-acl and puppetlabs-scheduled\_task are compatible.

## Release 0.4.1

**Bug fixes**

* Sets `inherit_parent_permissions` to `false` for lastrun ACLs on Windows. This should work around some observed idempotence issues with the ACL type and this property.

## Release 0.4.0

**Features**

* Manage ACEs for last\_run files to work around PUP-9238 bug
