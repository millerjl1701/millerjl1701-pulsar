# @api private
#
# This class is called from the main pulsar class for install.
#
class pulsar::gcc {
  assert_private('pulsar::gcc is a private class')
  if $pulsar::manage_gcc {
    include gcc
  }
}
