class glusterfs::server::service {

  service{ 'glusterd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}

