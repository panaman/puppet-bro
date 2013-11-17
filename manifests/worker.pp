define bro::worker (
  $host="$::hostname",
  $int=$title,
  $order=20,
  $method='UNSET',
  $procs='UNSET',
  $cpus='UNSET',
  ) {
  $basedir=$bro::basedir
  $type=$bro::type
  if ($method != 'UNSET' ) and ($cpus != 'UNSET') and ($type == 'cluster') {
    if is_array($cpus) {
      $bro_firstcpu = values_at($cpus, 0)
      $bro_lastcpu = values_at($cpus, 1)
    } else {
      $bro_firstcpu = $cpus
      $bro_lastcpu = $cpus
    }
    $bro_cpu_range = range("$bro_firstcpu", "$bro_lastcpu")
    $bro_cpu_pin = join($bro_cpu_range, ",")
    $bro_cpu_count = count($bro_cpu_range)
    concat::fragment { "${host}_${int}":
      target => "${basedir}/etc/node.cfg",
      content => template('bro/worker_name.erb'),
    }
  } elsif ($method != 'UNSET' ) and ($cpus == 'UNSET') and ($procs != 'UNSET') and ($type == 'cluster') {
    concat::fragment { "${host}_${int}":
      target => "${basedir}/etc/node.cfg",
      content => template('bro/worker_name.erb'),
    }
  } elsif ($method != 'UNSET' ) and ($cpus == 'UNSET') and ($procs == 'UNSET') and ($type == 'cluster') {
    notify{'BROken - MUST SET CPUS OR PROCS':}
  } elsif ($method == 'UNSET' ) and ($cpus == 'UNSET') and ($procs == 'UNSET') and ($type == 'cluster') {
    concat::fragment { "${host}_${int}":
      target => "${basedir}/etc/node.cfg", 
      content => template('bro/worker_name.erb'),
    }
  } else {}
}
