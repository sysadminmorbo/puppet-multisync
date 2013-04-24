# == Resource: multisync::groupmember
#
# Internal resource that's exported by multisync::member to provide
# configuration for the compilation script.
#
# === Authors
#
# Ingmar Steen <iksteen@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ingmar Steen, unless otherwise noted.
#
define multisync::groupmember(
    $path,
    $host,
    $group    = $title,
) {
  file { "${::multisync_basedir}/groups/${group}/${host}":
    ensure  => file,
    content => $path,
    notify  => Exec['compile multisync config'],
  }
}
