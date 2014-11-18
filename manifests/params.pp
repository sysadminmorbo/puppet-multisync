# == Class: multisync::params
#
# This class provides the default global configuration for the multisync
# module.
#
# === Authors
#
# Ingmar Steen <iksteen@gmail.com>
#
# === Copyright
#
# Copyright 2013 Ingmar Steen, unless otherwise noted.
#
class multisync::params {
  case $::osfamily {
    RedHat:  { $csync2_confdir = '/etc/csync2' }
    default: { $csync2_confdir = '/etc'        }
  }
}
