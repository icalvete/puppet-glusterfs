define glusterfs::volume::mount (

  $volume_name       = undef,
  $volume_mountpoint = undef

) {

    if ! $volume_name {
      fail ('volume_name is needed')
    }
  
    if ! $volume_mountpoint {
      fail ('volume_mountpoint is needed')
    }
  
    mount{ $volume_mountpoint:
    ensure  => mounted,
    device  => "${::ipaddress_eth1}:${volume_name}",
    fstype  => 'glusterfs',
    options => 'defaults',
    dump    => 1,
    pass    => 2,
  }

}
