class glusterfs::server::service {

  service{ 'glusterd':
    enable     => true,
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
  }
}

