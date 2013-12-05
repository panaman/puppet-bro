Bro NSM Puppet Module
=====================
Puppet module to manage a Bro Network Security Monitor. 
(To learn more about Bro visit the organizations website: http://www.bro.org)

###Description
This module has been tested on Centos 6.4 and Ubuntu 12.04. It should work on any Redhat or Debian based system.
Redhat systems can install from pre-built bro.org package. Debian systems will need to set pkg_source => 'none', then prebuild and install the package manually.

If running with pfring you will need to compile custom packages.

###Standalone Bro - RedHat
```
  class { 'bro':
    int => 'eth2',
  }
```
###Standalone Bro - Debian
```
  class { 'bro':
    pkg_source => 'none',
    int        => 'eth2',
  }
```
###Basic Bro Cluster
```
  class { 'bro':
    manager => 'sensor01',
    proxy   => 'sensor01',
    network => ['192.168.10.0/24','192.168.11.0/24'],
    type    => 'cluster',
  }
  bro::worker { 'eth1':
    host      => 'sensor01',
  }
  bro::worker { 'eth2':
    host      => 'sensor01',
  }
```
###Advanced - Bro Cluster : Pfring
You must specify cpus or procs when method is in use.
cpus ['1','4'] represents cpus 1,2,3,4 and will also place lb_procs value of 4.
```
  class { 'bro':
    manager => 'sensor01',
    proxy   => 'sensor01',
    network => ['192.168.10.0/24','192.168.11.0/24'],
    type    => 'cluster',
  }
  bro::worker { 'eth1':
    host      => 'sensor01',
    method    => 'pfring',
    cpus      => ['1','4'],
  }
  bro::worker { 'eth2':
    host      => 'sensor01',
    method    => 'pfring',
    procs     => '7',
  }
```
###Advanced - Bro Cluster : Myrcom
  ```
  class { 'bro':
    manager => 'sensor01',
    proxy   => 'sensor01',
    network => ['192.168.10.0/24','192.168.11.0/24'],
    type    => 'cluster',
  }
  bro::worker { 'eth1':
    host      => 'sensor01',
    method    => 'myricom',
    procs     => '12'
  }
```
###Other Customizable Variables
```
class { 'bro':
  $ensure       = 'running' # Toggle Bro on or off
  $pf_cid       = 'UNSET' # Customize Pfring Cluster ID
  $debug        = '0' # Toggle Debug on and off, 0 = Off and 1 = On
  $mailto       = 'root@localhost' # Change notice email
  $sitepolicy   = 'local.bro'# Change the default site policy file. This is useful when customizing bro.
  $logexpire    = '30' # Log Expire days
  $mindisk      = '5' # Min disk threshold
  $logrotate    = '3600' # Rotate logs every 3600 seconds
  $basedir      = '/opt/bro' # Bro base install dir
  $logdir       = '/var/opt/bro' # Bro Log Dir
  $manager      = $::hostname # Manager host
  $int          = $::hostint  # Sniffing Interface 
  $worker       = $::hostname # Worker host
  $proxy        = $::hostname # Proxy host
  $pkg_ensure   = 'present' # Ensure bro package, only valid with pkg_source => 'bro.org' or 'repo'
  $pkg          = 'bro' # Package title
  $pkg_source   = 'bro.org' # Source of package installs from bro.org. Only valid on RedHat based.
                  'repo' # This value assumes you have a custom repository with pre-built packages.
                  'none' # No package dependency. Asumes you built package from source.
  $type         = 'standalone' # Standalone bro
                = 'cluster' # Running bro in a cluster
  $network      = $::hostint_ipv4_cidr # Accepts an array of cidr blocks
  $bro_pkg_name = $::osfamily ? {
    'RedHat' => 'Bro-2.2-Linux-x86_64.rpm',
    'Debian' => 'Bro-2.2-Linux-x86_64.deb',
  }
  $bro_url = 'http://www.bro.org/downloads/release'
}
```
###Support
Please log tickets and issues at our [Projects site](https://github.com/panaman/puppet-bro/issues)
