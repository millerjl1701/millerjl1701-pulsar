# @api private
#
# This class is called from the main pulsar class for install.
#
class pulsar::install {
  assert_private('pulsar::install is a private class')
  File {
      owner  => $pulsar::pulsar_owner,
      group  => $pulsar::pulsar_group,
      mode   => $pulsar::pulsar_dirmode,
  }
  Python::Virtualenv {
      owner  => $pulsar::pulsar_owner,
      group  => $pulsar::pulsar_group,
      mode   => $pulsar::pulsar_dirmode,
  }

  if $pulsar::pulsar_pip_install {
    file { $pulsar::pulsar_dir:
      ensure => directory,
    }
    python::virtualenv { "${pulsar::pulsar_dir}/venv":
      ensure  => present,
      require => File[$pulsar::pulsar_dir],
    }
    $_requirements = $pulsar::pulsar_requirements
    file { "${pulsar::pulsar_dir}/requirements.txt":
      ensure  => present,
      mode    => $pulsar::pulsar_filemode,
      content => template('pulsar/requirements.txt.erb'),
      require => File[$pulsar::pulsar_dir],
    }
    python::requirements { 'pulsar_pip_requirements':
      requirements           => "${pulsar::pulsar_dir}/requirements.txt",
      virtualenv             => "${pulsar::pulsar_dir}/venv",
      owner                  => $pulsar::pulsar_owner,
      group                  => $pulsar::pulsar_group,
      cwd                    => $pulsar::pulsar_dir,
      manage_requirements    => false,
      fix_requirements_owner => true,
      log_dir                => $pulsar::pulsar_dir,
      require                => File["${pulsar::pulsar_dir}/requirements.txt"],
    }
  }
  else {
    vcsrepo { $pulsar::pulsar_dir:
      ensure   => present,
      provider => git,
      source   => $pulsar::pulsar_git_repository,
      revision => $pulsar::pulsar_git_revision,
      user     => $pulsar::pulsar_owner,
      owner    => $pulsar::pulsar_owner,
      group    => $pulsar::pulsar_group,
    }
    python::virtualenv { "${pulsar::pulsar_dir}/.venv":
      ensure  => present,
      require => Vcsrepo[$pulsar::pulsar_dir],
    }
    file { "${pulsar::pulsar_dir}/requirements.txt":
      ensure  => present,
      require => Vcsrepo[$pulsar::pulsar_dir],
    }
    python::requirements { 'pulsar_pip_requirements':
      requirements           => "${pulsar::pulsar_dir}/requirements.txt",
      virtualenv             => "${pulsar::pulsar_dir}/.venv",
      owner                  => $pulsar::pulsar_owner,
      group                  => $pulsar::pulsar_group,
      cwd                    => $pulsar::pulsar_dir,
      manage_requirements    => false,
      fix_requirements_owner => true,
      log_dir                => $pulsar::pulsar_dir,
    }
  }
}
