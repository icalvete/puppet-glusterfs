define glusterfs::peer::probe {

  if $name != $::ipaddress_eth1 {
    exec{ "probe_peer_${name}":
      command   => "/usr/sbin/gluster peer probe ${name}",
      tries     => '10',
      try_sleep => '30'
    }
  }
}

