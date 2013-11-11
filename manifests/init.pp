class bro(
  $ensure = 'running',
  $pkg_require = 'true',
  $mods = 'false',
  $pkg_ensure = 'present',
  $pkg_provider = $bro::params::pkg_provider,
  $pkg_source = "$bro::params::pkg_source",
  $basedir = '/opt/bro',
  $logdir = '/var/opt/bro',
  $logrotation = '3600',
  $logexpire = '5',
  $mindisk = '5',
  $mailto = 'root@localhost',
  $debug = '0',
  $manager = $hostname,
  $pfring = 'false',
  $proxy = $hostname,
  $interface = $::hostint,
  $wkr1 = 'NA',
  $wkr1_cpus = 'NA',
  $wkr1_int = 'NA',
  $wkr2 = 'NA',
  $wkr2_cpus = 'NA',
  $wkr2_int = 'NA',
  $wkr3 = 'NA',
  $wkr3_cpus = 'NA',
  $wkr3_int = 'NA',
  $wkr4 = 'NA',
  $wkr4_cpus = 'NA',
  $wkr4_int = 'NA',
  $wkr5 = 'NA',
  $wkr5_cpus = 'NA',
  $wkr5_int = 'NA',
  $wkr6 = 'NA',
  $wkr6_cpus = 'NA',
  $wkr6_int = 'NA',
  $wkr7 = 'NA',
  $wkr7_cpus = 'NA',
  $wkr7_int = 'NA',
  $wkr8 = 'NA',
  $wkr8_cpus = 'NA',
  $wkr8_int = 'NA',
  $wkr9 = 'NA',
  $wkr9_cpus = 'NA',
  $wkr9_int = 'NA',
  $wkr10 = 'NA',
  $wkr10_cpus = 'NA',
  $wkr10_int = 'NA',
  ) inherits bro::params {
  if ($wkr1_cpus != 'NA' ) {
    if is_array($wrk1_cpus) {
      $bro_firstcpu = values_at($wkr1_cpus, 0)
      $bro_lastcpu = values_at($wkr1_cpus, 1)
    } else {
      $bro_firstcpu = $wkr1_cpus
      $bro_lastcpu = $wkr1_cpus
    }
    $bro_cpu_range = range("$bro_firstcpu", "$bro_lastcpu")
    $bro_cpu_pin = join($bro_cpu_range, ",")
    $bro_cpu_count = count($bro_cpu_range)
  } else {}
  if ( $ensure == 'running' ) {
    $bro_present = 'present'
    $bro_state  = 'running'
  } else {
    $bro_present = 'absent'
    $bro_state  = 'stopped'
  }
  if ( $pkg_require == 'true' ) {
    package { 'bro':
      provider => $pkg_provider,
      ensure   => $bro_present,
      source   => $pkg_source,
      notify => Service['wassup_bro'],
    }
  } else {}
  File {
    ensure => present,
    mode   => '0644',
    owner  => '0',
    group  => '0',
  }
  file { $basedir:
    ensure => directory,
  }
  $bro_dirs = [
    "$basedir/share/bro/site",
    "$basedir/etc"
  ]
  file { $bro_dirs:
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }
  if ( $mods == 'true' ) {
    file { 'mods':
      name    => "$basedir/share/bro/site/mods",
      recurse => true,
      purge   => true,
      force   => true,
      source  => "puppet:///modules/bro/mods",
      notify  => Service['wassup_bro'],
    }
  } else {}
  $localbro_default = "puppet:///modules/bro/localbro/local.bro.default"
  $localbro_custom = "puppet:///modules/bro/localbro/local.bro.${hostname}"
  file { "$basedir/share/bro/site/local.bro":
    source => [ "$localbro_custom","$localbro_default" ],
    notify => Service['wassup_bro'],
  }
  
  file { "$basedir/bin/wassup_bro":
    mode => '0755',
    content => template('bro/wassup_bro.erb'),
  }
  $status = "$basedir/bin/wassup_bro status | grep running"
  $start = "$basedir/bin/wassup_bro start"
  $stop = "$basedir/bin/wassup_bro stop"
  $restart = "$basedir/bin/wassup_bro restart"
  service { 'wassup_bro':
    ensure  => $bro_state,
    status  => $status,
    start   => $start,
    restart => $restart,
    stop    => $stop,
    require => File["$basedir/bin/wassup_bro"],
  }
  cron { 'bro_cron':
    ensure  => $bro_present,
    command => "$basedir/bin/broctl cron",
    user    => '0',
    minute  => '*/5',
  }
  file { "${basedir}/etc/broctl.cfg":
    content => template('bro/broctl.cfg.erb'),
    notify  => Service['wassup_bro'],
  }
  file { "${basedir}/etc/node.cfg":
    content => template('bro/node.cfg.erb'),
    notify  => Service['wassup_bro'],
  }
  ### need more work
  file { "${basedir}/etc/networks.cfg":
    content => template('bro/networks.cfg.erb'),
    notify  => Service['wassup_bro'],
  }
  file { '/opt/bro/share/bro/site/local-manager.bro':
    content => "# Manager\n",
  }
  file { '/opt/bro/share/bro/site/local-proxy.bro':
    content => "# Proxy\n",
  }
  file { '/opt/bro/share/bro/site/local-worker.bro':
    content => "# Worker\n",
  }


}
