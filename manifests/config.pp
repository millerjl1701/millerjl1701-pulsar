# @api private
#
# This class is called from pulsar for service config.
#
class pulsar::config {
  assert_private('pulsar::config is a private class')

  $_config_dir          = $pulsar::pulsar_config_dir
  $_managers            = $pulsar::pulsar_named_managers
  $_persistence_dir     = $pulsar::pulsar_persistence_dir
  $_pip_install         = $pulsar::pulsar_pip_install
  $_staging_dir         = $pulsar::pulsar_staging_dir
  $_tool_dependency_dir = $pulsar::pulsar_tool_dependency_dir
  $_use_uuids           = $pulsar::pulsar_use_uuids

  if $pulsar::pulsar_drmaa_path {
    $_drmaa_path = $pulsar::pulsar_drmaa_path
  }
  if $pulsar::pulsar_file_cache_dir {
    $_file_cache_dir = $pulsar::pulsar_file_cache_dir
  }
  if $pulsar::pulsar_galaxy_path {
    $_galaxy_path = $pulsar::pulsar_galaxy_path
  }
  if $pulsar::pulsar_galaxy_venv_path {
    $_galaxy_venv = $pulsar::pulsar_galaxy_venv_path
  }
  if $pulsar::pulsar_galaxy_verify {
    $_galaxy_verify = $pulsar::pulsar_galaxy_verify
  }
  if $pulsar::pulsar_job_directory_mode {
    $_job_directory_mode = $pulsar::pulsar_job_directory_mode
  }
  if $pulsar::pulsar_job_run_as_user {
    $_job_run_as_user = $pulsar::pulsar_job_run_as_user
  }
  if $pulsar::pulsar_pip_install {
    $_pulsar_venv = "${pulsar::pulsar_dir}/venv"
  }
  else {
    $_pulsar_venv = "${pulsar::pulsar_dir}/.venv"
  }
  if $pulsar::pulsar_private_token {
    $_private_token = $pulsar::pulsar_private_token
  }

  file { "${pulsar::pulsar_config_dir}/app.yml":
    ensure  => present,
    owner   => $pulsar::pulsar_owner,
    group   => $pulsar::pulsar_group,
    mode    => $pulsar::pulsar_filemode,
    content => template($pulsar::pulsar_template_app),
  }
  file { "${pulsar::pulsar_config_dir}/local_env.sh":
    ensure  => present,
    owner   => $pulsar::pulsar_owner,
    group   => $pulsar::pulsar_group,
    mode    => $pulsar::pulsar_filemode,
    content => template($pulsar::pulsar_template_local_env),
  }
  file { "${pulsar::pulsar_config_dir}/run.sh":
    ensure  => present,
    owner   => $pulsar::pulsar_owner,
    group   => $pulsar::pulsar_group,
    mode    => $pulsar::pulsar_dirmode,
    content => template($pulsar::pulsar_template_run),
  }
  file { "${pulsar::pulsar_config_dir}/server.ini":
    ensure  => present,
    owner   => $pulsar::pulsar_owner,
    group   => $pulsar::pulsar_group,
    mode    => $pulsar::pulsar_filemode,
    content => template($pulsar::pulsar_template_server),
  }
  file { $pulsar::pulsar_logdir:
    ensure  => directory,
    owner   => $pulsar::pulsar_owner,
    group   => $pulsar::pulsar_group,
    mode    => $pulsar::pulsar_dirmode,
  }
}
