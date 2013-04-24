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
# === Examples
#
#  multisync::member { 'my_sync_group':
#    path => '/srv/sync_group',
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
) {
  @@multisync::groupmember { "${group} - ${::fqdn}":
    group => $group,
    path  => $path,
    host  => $::fqdn,
  }

  multisync::group { $group:
    path => $path,
  }
}
