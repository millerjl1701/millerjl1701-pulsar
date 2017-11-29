# @api private
#
# This class is called from the main pulsar class for install.
#
class pulsar::install {
  assert_private('pulsar::install is a private class')

  if $pulsar::manage_python {
    class { 'python':
      dev             => $::pulsar::manage_python_dev,
      manage_gunicorn => false,
      use_epel        => $::pulsar::manage_python_use_epel,
      virtualenv      => $::pulsar::manage_python_virtualenv,
    }
  }
}
