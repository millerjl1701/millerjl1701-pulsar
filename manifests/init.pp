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
# @param pulsar_config_dir Directory for where to place configuration files.
# @param pulsar_dir Directory for where to install pulsar.
# @param pulsar_dirmode Mode to use for pulsar directories.
# @param pulsar_drmaa_path Path to libdrmaa.so.
# @param pulsar_filemode Mode to use for pulsar files.
# @param pulsar_file_cache_dir Directory used to store incoming file cache.
# @param pulsar_galaxy_path Path to Galaxy.
# @param pulsar_galaxy_venv_path Path to the virtualenv for Galaxy
# @param pulsar_galaxy_verify Whether or not to verify if the path to galaxy is properly set before starting pulsar.
# @param pulsar_git_repository URL of the pulsar git repository.
# @param pulsar_git_revision Revision, tag, or commit id of the pulsar git repository to use.
# @param pulsar_group Group that should be used for pulsar server and configuration files.
# @param pulsar_job_directory_mode Mode for job related directories.
# @param pulsar_job_run_as_user Whether or not pulsar should run jobs as the real user in galaxy or not.
# @param pulsar_named_managers Hash of named managers for pulsar.
# @param pulsar_owner Owner that should be assigned to pulsar server and configuration files.
# @param pulsar_persistence_dir Directory for pulsar to store information about active jobs.
# @param pulsar_pip_install Whether to install by pip or by using the gitrepo instead of pip.
# @param pulsar_private_token Private token that must be sent as part of request to authorize use.
# @param pulsar_requirements What pip packages to install into the pulsar virtual environment.
# @param pulsar_staging_dir Directory to stage files.
# @param pulsar_template_app Template to use for app.yml file.
# @param pulsar_template_local_env Template to use for local_env.sh file.
# @param pulsar_template_run Template to use for run.sh file.
# @param pulsar_template_server Template to use for server.ini file.
# @param pulsar_tool_dependency_dir Directory use by tool dependency resolves to find dependency scripts.
# @param pulsar_use_uuids Whether or not pulsar should assign UUID to jobs.
# @param service_enable Whether to enable the pulsar service at boot.
# @param service_ensure Whether the pulsar service should be running.
# @param service_name Specifies the name of the service to manage.
#
class pulsar (
  Boolean                         $manage_gcc                 = true,
  Boolean                         $manage_git                 = true,
  Boolean                         $manage_python              = true,
  Enum['present', 'absent']       $manage_python_dev          = 'present',
  Boolean                         $manage_python_use_epel     = true,
  Enum['present', 'absent']       $manage_python_virtualenv   = 'present',
  Stdlib::Absolutepath            $pulsar_config_dir          = '/opt/pulsar',
  Stdlib::Absolutepath            $pulsar_dir                 = '/opt/pulsar',
  String                          $pulsar_dirmode             = '0775',
  Optional[Stdlib::Absolutepath]  $pulsar_drmaa_path          = undef,
  String                          $pulsar_filemode            = '0664',
  Optional[Stdlib::Absolutepath]  $pulsar_file_cache_dir      = undef,
  Optional[Stdlib::Absolutepath]  $pulsar_galaxy_path         = undef,
  Optional[Stdlib::Absolutepath]  $pulsar_galaxy_venv_path    = undef,
  Boolean                         $pulsar_galaxy_verify       = false,
  Stdlib::Httpurl                 $pulsar_git_repository      = 'https://github.com/galaxyproject/pulsar',
  String                          $pulsar_git_revision        = 'master',
  String                          $pulsar_group               = 'galaxy',
  Optional[String]                $pulsar_job_directory_mode  = undef,
  Boolean                         $pulsar_job_run_as_user     = false,
  Stdlib::Absolutepath            $pulsar_logdir              = '/var/log/pulsar',
  Integer                         $pulsar_num_backups         = 10,
  Hash                            $pulsar_named_managers      = { '__default__' => {'type' =>'queued_python', 'num_concurrent_jobs' => 'i', } },
  String                          $pulsar_owner               = 'galaxy',
  String                          $pulsar_persistence_dir     = "${pulsar_dir}/files/persisted_data",
  Boolean                         $pulsar_pip_install         = true,
  Optional[String]                $pulsar_private_token       = undef,
  Array                           $pulsar_requirements        = [ 'pulsar-app', ],
  Stdlib::Absolutepath            $pulsar_staging_dir         = "${pulsar_dir}/files/staging",
  String                          $pulsar_template_app        = 'pulsar/app.yml.erb',
  String                          $pulsar_template_local_env  = 'pulsar/local_env.sh.erb',
  String                          $pulsar_template_run        = 'pulsar/run.sh.erb',
  String                          $pulsar_template_server     = 'pulsar/server.ini.erb',
  String                          $pulsar_template_service    = 'pulsar/supervisor_pulsar.conf.erb',
  Stdlib::Absolutepath            $pulsar_tool_dependency_dir = "${pulsar_dir}/dependencies",
  Boolean                         $pulsar_use_uuids           = false,
  Boolean                         $service_enable             = true,
  Enum['running', 'stopped']      $service_ensure             = 'running',
  Boolean                         $service_manage_config      = true,
  Stdlib::Absolutepath            $service_manage_configdir   = '/etc/supervisor/conf.d',
  String                          $service_name               = 'pulsar',
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
