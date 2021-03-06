# == Class: duo_unix::yum
#
# Provides duo_unix for a yum-based environment (e.g. RHEL/CentOS)
#
# === Authors
#
# Mark Stanislav <mstanislav@duosecurity.com>
#
class duo_unix::yum {
  $repo_uri = 'http://pkg.duosecurity.com'
  package {  [ 'openssh-server', $duo_unix::duo_package ]:
    ensure  => latest,
    require => [ Yumrepo['duosecurity'], Exec['Duo Security GPG Import'] ];
  }

  yumrepo { 'duosecurity':
    descr    => 'Duo Security Repository',
    baseurl  => "${repo_uri}/${::operatingsystem}/\$releasever/\$basearch",
    gpgcheck => '1',
    enabled  => '1',
    require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-DUO'];
  }

  exec { 'Duo Security GPG Import':
    command => '/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-DUO',
    unless  => '/bin/rpm -qi gpg-pubkey | grep Duo > /dev/null 2>&1'
  }
}
