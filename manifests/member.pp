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
