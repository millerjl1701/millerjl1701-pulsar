# Class: pulsar
# ===========================
#
# Main class that includes all other classes for the pulsar module.
#
# @param [Boolean] Whether or not to manage python with this module. Default value: true.
# @param [String] Installation state for python-dev to be passed to the python module. Valid values are: present, absent. Default value: present.
# @param [Boolean] Whether or not the python module should manage the use of epel. Default value: true.
# @param [String] Installation state for python-virtualenv to be passed to the python module. Valid values: present, absent. Default value: present.
# @param [Boolean] service_enable Whether to enable the pulsar service at boot. Default value: true.
# @param [String] service_ensure Whether the pulsar service should be running. Default value: 'running'.
# @param [String] service_name Specifies the name of the service to manage. Default value: 'pulsar'.
#
class pulsar (
  $manage_python            = true,
  $manage_python_dev        = 'present',
  $manage_python_use_epel   = $pulsar::params::manage_python_use_epel,
  $manage_python_virtualenv = 'present',
  $service_enable           = true,
  $service_ensure           = 'running',
  $service_name             = $pulsar::params::service_name,
) inherits ::pulsar::params {
  validate_bool($manage_python)
  validate_re($manage_python_dev, [ '^present$', '^absent$', ])
  validate_bool($manage_python_use_epel)
  validate_re($manage_python_virtualenv, [ '^present$', '^absent$', ])
  validate_bool($service_enable)
  validate_re($service_ensure, [ '^running$', '^stopped$', ])
  validate_string($service_name)

  class{ '::pulsar::python': } -> class { '::pulsar::install': } -> class { '::pulsar::config': } ~> class { '::pulsar::service': } -> Class['::pulsar']
}
