# @api private
#
# This class manages the Pulsar parameters that could be operating system dependent.
class pulsar::params {
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      case $::operatingsystemmajrelease {
        '6', '7': {
          $manage_python_use_epel = true
          $service_name = 'pulsar'
        }
        default: {
          fail("${::operatingsystem} ${::operatingsystemmajrelease} is not supported.")
        }
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
