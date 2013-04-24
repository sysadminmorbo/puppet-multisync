multisync
=========

This is a module to set up multi-server / cluster synchronization using
lsyncd and csync2.

You can use this to synchronize directories between servers. It uses a
chained csync2 configuration that is triggered by lsyncd. It is based on
this method: http://bit.ly/NCn7I4

This method depends on csync2 1.34 and lsyncd >= 2.0.0.

Currently, it supports setting up the synchronization on Arch Linux,
CentOS 6 (lsyncd / csync2 can be found in the EPEL repository) and
Debian Wheezy (Squeeze does not provide a new enough lsyncd package).

License
-------

Apache License, version 2.0

Usage
-----

Before creating a sync group you need to generate a key using the
"csync2 -k" manually and copy the resulting key file to the files
directory of this module. Give it the same name as the sync group
you intend to and add a .key extension. The, use the following
resource on at least two hosts to set everything up.

<pre>
multisync::member { 'my_sync_group':
  path => '/srv/my_sync_group',
}
</pre>

Contact
-------

Ingmar Steen <iksteen@gmail.com>

Support
-------

Please log issues at the [project site](http://github.com/iksteen/puppet-multisync)
