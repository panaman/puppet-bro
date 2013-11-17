class bro::broctl(
  $pf_cid = $bro::pf_cid,
  $basedir = $bro::basedir,
  $logdir = $bro::logdir,
  $debug = $bro::debug,
  $mailto = $bro::mailto,
  $sitepolicy = $bro::sitepolicy,
  $logexpire = $bro::logexpire,
  $mindisk = $bro::mindisk,
  $logrotate = $bro::logrotate,
  ) inherits bro {
  if ($pf_cid != 'UNSET') {
    $cid = "PFRINGClusterID = $pf_cid"
  } else {
    $cid = ""
  }
  tps::report { "$basedir/etc/broctl.cfg":
    flare => [
      '# PUPPET MANAGED CONFIG',
      "$cid", 
      "MailTo = $mailto",
      "SitePolicyStandalone = $sitepolicy",
      "CfgDir = $basedir/etc",
      "SpoolDir = $logdir/spool",
      "LogDir = $logdir/logs",
      "LogRotationInterval = $logrotate",
      "MinDiskSpace = $mindisk",
      "Debug = $debug",
    ],
    notify  => Service['wassup_bro'],
  }
}
