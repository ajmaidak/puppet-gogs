class gogs::service
  (

    $service_ensure         = $gogs::params::service_ensure,
    $service_name           = $gogs::service_name,
    $installation_directory = $gogs::installation_directory,
    $sysconfig              = $gogs::sysconfig,

  ) inherits gogs::params {

  file { $gogs::params::init_script:
    ensure => file,
    source => $gogs::params::gogs_init_script,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

    ->

    file { '/etc/init.d/functions':
      ensure => created,
      owner  => 'root',
      group  => 'root',
    }

  create_resources('gogs::sysconfig', $sysconfig)

  service { $service_name:
    ensure     => $service_ensure,
    hasrestart => true, # let puppet start and stop (restart seems to be not working)
    hasstatus  => true, # let puppet check for the process in process list (status command seems to be not working )
    enable     => true,
  }
}
