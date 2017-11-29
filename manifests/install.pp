# @api private
#
# This class is called from the main pulsar class for install.
#
class pulsar::install {
  assert_private('pulsar::install is a private class')

  package { $::pulsar::package_name:
    ensure => $::pulsar::package_ensure,
  }
}
