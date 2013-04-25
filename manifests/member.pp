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
    $group = $title,
    $key   = undef,
) {
  $key_real = $key ? {
    undef   => "puppet:///modules/multisync/${group}.key",
    default => $key,
  }

  @@multisync::groupmember { "${group} - ${::fqdn}":
    group => $group,
    path  => $path,
    host  => $::fqdn,
  }

  multisync::group { $group:
    path => $path,
    key  => $key_real,
  }
}
