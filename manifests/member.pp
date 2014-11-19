# == Class: multisync::member
#
# Use this resource to set a client up as a member of a sync group.
#
# === Parameters
#
# [*group*]
#   The synchronization group this client is a member of. Defaults to
#   $title.
#
# [*path*]
#   Specify the path on the client that is synchronized.
#
# [*key*]
#   Specify the key file to use. Defaults to
#   puppet:///modules/multisync/${group}.key. If you use this, be
#   aware that it is always copied to /etc/csync2_${group}.key.
#
# [*path_owner*']
#   Specify the owner of the synchronisation path. Defaults to root.
#
# [*path_group*]
#   Specify the group of the synchronisation path. Defaults to root.
#
# [*path_mode*]
#   Specify the access mode of the synchronisation path. Defaults to '0755'.
#
# === Examples
#
#  multisync::member { 'my_sync_group':
#    path => '/srv/sync_group',
#    key  => 'puppet:///modules/my_module/csync2.key',
#  }
#
# === Authors
#
# Ingmar Steen <iksteen@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ingmar Steen, unless otherwise noted.
#
define multisync::member(
    $path,
    $group      = $title,
    $key        = undef,
    $path_owner = 'root',
    $path_group = 'root',
    $path_mode  = '0755',
) {
  $key_real = $key ? {
    undef   => "puppet:///modules/multisync/${group}.key",
    default => $key,
  }

  @@multisync::groupmember { "${group} - ${::hostname}":
    group => $group,
    path  => $path,
    host  => $::fqdn,
  }

  multisync::group { $group:
    path       => $path,
    key        => $key_real,
    path_owner => $path_owner,
    path_group => $path_group,
    path_mode  => $path_mode,
  }
}
