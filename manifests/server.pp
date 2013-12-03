class glusterfs::server {

  anchor {'glusterfs::server::begin':
    before => Class['glusterfs::server::install']
  }
  class {'glusterfs::server::install':
    require => Anchor['glusterfs::server::begin']
  }
  class {'glusterfs::server::config':
    require => Class['glusterfs::server::install']
  }
  class {'glusterfs::server::service':
    require => Class['glusterfs::server::config']
  }
  anchor {'glusterfs::server::end':
    require => Class['glusterfs::server::service']
  }
}
