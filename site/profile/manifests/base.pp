class profile::base {

  #the base profile should include component modules that will be on all nodes

  file { '/etc/fuckyeah':
    ensure  => file,
    owner   => 'root',
    content => 'This absolutely must not change',
  }
}
