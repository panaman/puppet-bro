class bro::params {
  $start = '/opt/bro/bin/broctl start'
  $restart = '/opt/bro/bin/broctl restart'
  $install = '/opt/bro/bin/broctl install'
  $stop = '/opt/bro/bin/broctl stop'
  $status = 'ps -ef | grep run-bro | grep -v grep'
  $ensure = 'running'
  $debug = '0'
  $bro_dir = '/opt/bro'
  $manager = $::hostname
  $proxy   = $::proxy
  $interface = undef
  $worker1 = "$::hostname-$interface"
  $pkg_provider = $::osfamily ? { 
     'RedHat' => 'rpm',
     'Debian' => 'apt',
  }
  $pkg_source = $::osfamily ? {
     'RedHat' => 'http://www.bro.org/downloads/release/Bro-2.2-Linux-x86_64.rpm',
     'Debian' => 'http://www.bro.org/downloads/release/Bro-2.2-Linux-x86_64.deb',
  }
}
