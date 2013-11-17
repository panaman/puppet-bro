class bro::pkg( 
  $pkg_source   = $bro::pkg_source,
  $bro_pkg_name = $bro::bro_pkg_name,
  $bro_url      = $bro::bro_url,
  $pkg          = $bro::pkg,
  $pkg_ensure   = $bro::pkg_ensure,
  ) inherits bro {
  case $pkg_source {
    'bro.org': {
      if ( $::osfamily == 'RedHat') {
        ensure_packages(['openssl','file-libs','python','bash','zlib','bind-utils','bind-libs','libpcap'])
        $pkg_location = "$bro_url/$bro_pkg_name"
        $pkg_provider = 'rpm'
        package { "$pkg":
          provider => $pkg_provider,
          ensure   => $pkg_ensure,
          source   => $pkg_location,
          notify => Service['wassup_bro'],
        }

      } elsif ( $::osfamily == 'Debian') {
        ensure_packages(['wget','libc6','python2.6','libssl0.9.8'])
        $pkg_location = "/usr/local/src/$bro_pkg_name"
        $pkg_provider = 'dpkg'
        $execlaunchpaths = ["/usr/bin", "/usr/sbin", "/bin", "/sbin", "/etc"]
        $executefrom = "/usr/local/src"
        exec { 'download_bro':
          command => "wget -d $bro_url/$bro_pkg_name",
          cwd     => "$executefrom",
          path    => $execlaunchpaths,
          creates => "$executefrom/$bro_pkg_name",
        }
        package { "$pkg":
          provider => $pkg_provider,
          ensure   => $pkg_ensure,
          source   => $pkg_location,
          require  => Exec['download_bro'],
          notify   => Service['wassup_bro'],
        }
      } else {}
    }
    'repo': {
      package { "$pkg":
        ensure   => $bro_present,
        notify   => Service['wassup_bro'],
      }
    }
    'none': {
    }
  }
}
