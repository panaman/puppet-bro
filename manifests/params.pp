class bro::params {
  $ensure       = 'running'
  $pf_cid       = 'UNSET'
  $broctl       = 'DEFAULT'
  $debug        = '0'
  $mailto       = 'root@localhost'
  $sitepolicy   = 'local.bro'
  $logexpire    = '30'
  $mindisk      = '5'
  $logrotate    = '3600'
  $logpurge     = 'disabled'
  $mods         = 'false'
  $basedir      = '/opt/bro'
  $logdir       = '/var/opt/bro'
  $manager      = $::hostname
  $interface    = $::hostint
  $worker       = $::hostname
  $proxy        = $::hostname
  $pkg_ensure   = 'present'
  $pkg          = 'bro'
  $pkg_source   = 'bro.org'
  $type         = 'standalone'
  $network      = $::hostint_ipv4_cidr 
  $etc_dir      = "$basedir/etc"
  $sitedir      = "$basedir/share/bro/site"
  $bro_pkg_name = $::osfamily ? {
    'RedHat' => 'Bro-2.3-Linux-x86_64.rpm',
    'Debian' => 'Bro-2.3-Linux-x86_64.deb',
  }
  $bro_url = 'http://www.bro.org/downloads/release'
}
