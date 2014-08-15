class bro::broctl(
  $pf_cid     = $bro::pf_cid,
  $basedir    = $bro::basedir,
  $logdir     = $bro::logdir,
  $debug      = $bro::debug,
  $mailto     = $bro::mailto,
  $sitepolicy = $bro::sitepolicy,
  $logexpire  = $bro::logexpire,
  $mindisk    = $bro::mindisk,
  $logrotate  = $bro::logrotate,
  $sitedir    = $bro::sitedir,
  $broctl     = $bro::broctl,
  ) inherits bro {
  if ($pf_cid != 'UNSET') {
    $cid = "PFRINGClusterID = $pf_cid"
  } else {
    $cid = ""
  }
  if ( $broctl == 'DEFAULT' ) {
    tps::report { "$basedir/etc/broctl.cfg":
      flare => [
        '# PUPPET MANAGED CONFIG',
        "$cid", 
        "SitePolicyPath = $sitedir",
        "MailTo = $mailto",
        "SitePolicyStandalone = $sitepolicy",
        "CfgDir = $etc_dir",
        "SpoolDir = $logdir/spool",
        "LogDir = $logdir/logs",
        "LogRotationInterval = $logrotate",
        "MinDiskSpace = $mindisk",
        "Debug = $debug",
      ],
      notify  => Service['wassup_bro'],
    }
  } elsif ( $broctl == 'CUSTOM' ) {
    file { "$basedir/etc/broctl.cfg":
      ensure => present,
      owner  => '0',
      group  => '0',
      mode   => '0644',
      source => [
        "puppet:///modules/bro/broctl/${::hostname}_broctl.cfg",
        "puppet:///modules/bro/broctl/custom_broctl.cfg",
      ], 
    }
  } else {
    notify { 'Invalaid broctl option, valid options are DEFAULT and CUSTOM': }
  }
}
