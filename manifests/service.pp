# @api private
#
# This class is meant to be called from pulsar to manage the pulsar service.
#
class pulsar::service {
  assert_private('pulsar::service is a private class')

  #service { $::pulsar::service_name:
  #  ensure     => $::pulsar::service_ensure,
  #  enable     => $::pulsar::service_enable,
  #  hasstatus  => true,
  #  hasrestart => true,
  #}
}
