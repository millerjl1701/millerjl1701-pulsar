# Class: pulsar
# ===========================
#
# Main class that includes all other classes for the pulsar module.
#
# @param manage_gcc Whether or not to manage gcc installation with this module.
# @param manage_git Whether or not to manage git installation with this module.
# @param manage_python Whether or not to manage python with this module.
# @param manage_python_dev Installation state for python-dev package to be passed to the python module.
# @param manage_python_use_epel Whether or not the python module should manage the use of epel.
# @param manage_python_virtualenv Installation state for python-virtualenv package to be passed to the python module.
# @param pulsar_dir Directory for where to install pulsar.
# @param pulsar_dirmode Mode to use for pulsar directories.
# @param pulsar_filemode Mode to use for pulsar files.
# @param pulsar_git_repository URL of the pulsar git repository.
# @param pulsar_git_revision Revision, tag, or commit id of the pulsar git repository to use.
# @param pulsar_group Group that should be used for pulsar server and configuration files.
# @param pulsar_owner Owner that should be assigned to pulsar server and configuration files.
# @param pulsar_pip_install Whether to install by pip or by using the gitrepo instead of pip.
# @param pulsar_requirements What pip packages to install into the pulsar virtual environment.
# @param service_enable Whether to enable the pulsar service at boot.
# @param service_ensure Whether the pulsar service should be running.
# @param service_name Specifies the name of the service to manage.
#
class pulsar (
  Boolean                     $manage_gcc               = true,
  Boolean                     $manage_git               = true,
  Boolean                     $manage_python            = true,
  Enum['present', 'absent']   $manage_python_dev        = 'present',
  Boolean                     $manage_python_use_epel   = true,
  Enum['present', 'absent']   $manage_python_virtualenv = 'present',
  Stdlib::Absolutepath        $pulsar_dir               = '/opt/pulsar',
  String                      $pulsar_dirmode           = '0775',
  String                      $pulsar_filemode          = '0664',
  Stdlib::Httpurl             $pulsar_git_repository    = 'https://github.com/galaxyproject/pulsar',
  String                      $pulsar_git_revision      = 'master',
  String                      $pulsar_group             = 'galaxy',
  String                      $pulsar_owner             = 'galaxy',
  Boolean                     $pulsar_pip_install       = true,
  Array                       $pulsar_requirements      = [ 'pulsar-app', ],
  Boolean                     $service_enable           = true,
  Enum['running', 'stopped']  $service_ensure           = 'running',
  String                      $service_name             = 'pulsar',
) {
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      case $::operatingsystemmajrelease {
        '7': {
          contain pulsar::gcc
          contain pulsar::git
          contain pulsar::python
          contain pulsar::install
          contain pulsar::config
          contain pulsar::service

          Class['pulsar::gcc']
          -> Class['pulsar::git']
          -> Class['pulsar::python']
          -> Class['pulsar::install']
          -> Class['pulsar::config']
          ~> Class['pulsar::service']
        }
        default: {
          fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
        }
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
