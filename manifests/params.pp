# @api private
#
# This class manages the Pulsar parameters
class pulsar::params {
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      case $::operatingsystemmajrelease {
        '6', '7': {
          $package_name = 'pulsar'
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
