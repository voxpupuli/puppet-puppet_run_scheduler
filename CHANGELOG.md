# Changelog

All notable changes to this project will be documented in this file.

## Release 0.4.1

**Bug fixes**

* Sets `inherit_parent_permissions` to `false` for lastrun ACLs on Windows. This should work around some observed idempotence issues with the ACL type and this property.

## Release 0.4.0

**Features**

* Manage ACEs for last\_run files to work around PUP-9238 bug
