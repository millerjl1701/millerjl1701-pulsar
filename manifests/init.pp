# Class: pulsar
# ===========================
#
# Main class that includes all other classes for the pulsar module.
#
# @param [String] package_ensure Whether to install the pulsar package, and/or what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param [String] package_name Specifies the name of the package to install. Default value: 'pulsar'.
# @param [Boolean] service_enable Whether to enable the pulsar service at boot. Default value: true.
# @param [String] service_ensure Whether the pulsar service should be running. Default value: 'running'.
# @param [String] service_name Specifies the name of the service to manage. Default value: 'pulsar'.
#
class pulsar (
  $manage_python            = true,
  $manage_python_dev        = 'present',
  $manage_python_use_epel   = true,
  $manage_python_virtualenv = 'present',
  $package_ensure           = 'present',
  $package_name             = 'pulsar',
  $service_enable           = true,
  $service_ensure           = 'running',
  $service_name             = 'pulsar',
) inherits ::pulsar::params {
  validate_bool($manage_python)
  validate_re($manage_python_dev, [ '^present$', '^absent$', ])
  validate_bool($manage_python_use_epel)
  validate_re($manage_python_virtualenv, [ '^present$', '^absent$', ])

  class { '::pulsar::install': } -> class { '::pulsar::config': } ~> class { '::pulsar::service': } -> Class['::pulsar']
}
