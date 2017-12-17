# @api private
#
# This class is called from the main pulsar class for install.
#
class pulsar::git {
  assert_private('pulsar::git is a private class')
  if $pulsar::manage_git {
    include git
  }
}
