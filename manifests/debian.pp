class subversion::debian inherits subversion::base {
  package {'subversion-tools': 
    ensure => present;
  }
}
