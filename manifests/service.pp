# @api private
#
# This class is meant to be called from pulsar to manage the pulsar service.
#
class pulsar::service {
  assert_private('pulsar::service is a private class')

  if $::pulsar::service_manage_config {
    $_service_name          = $pulsar::service_name
    $_pulsar_owner          = $pulsar::pulsar_owner
    $_pulsar_group          = $pulsar::pulsar_group
    $_pulsar_dir            = $pulsar::pulsar_dir
    $_pulsar_logdir         = $pulsar::pulsar_logdir
    $_pulsar_log_numbackups = $pulsar::pulsar_num_backups
    if $pulsar::service_enable {
      $_pulsar_autostart   = 'true'
      $_pulsar_autorestart = 'true'
    }
    else {
      $_pulsar_autostart   = 'false'
      $_pulsar_autorestart = 'false'
    }
    if $pulsar::pulsar_pip_install {
      $_pulsar_venv_dir = "${pulsar::pulsar_dir}/venv"
    }
    else {
      $_pulsar_venv_dir = "${pulsar::pulsar_dir}/.venv"
    }

    file { "${::pulsar::service_manage_configdir}/${::pulsar::service_name}.conf":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($pulsar::pulsar_template_service),
      notify  => [ Exec['pulsar_supervisord_reread_config'], Service[$::pulsar::service_name], ],
    }
    exec { 'pulsar_supervisord_reread_config':
      command     => 'supervisorctl update',
      path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin:/root/bin',
      refreshonly => true,
      notify      => Service[$::pulsar::service_name],
    }
  }

  service { $::pulsar::service_name:
    ensure  => $::pulsar::service_ensure,
    status  => '/bin/ps -C pulsar -o pid=',
    start   => "supervisorctl start ${::pulsar::service_name}",
    stop    => "supervisorctl stop ${::pulsar::service_name}",
    restart => "supervisorctl restart ${::pulsar::service_name}",
  }
}
