class glusterfs::params {

  case $::operatingsystem {
    debian,ubuntu,centos,redhat :{
      $package = 'glusterfs-server'
    }
    default: {
      fail("Operating system $operatingsystem is not supported")
    }
  }
}

