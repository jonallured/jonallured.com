error_messages = {
  1 => 'Middleman failed to build site',
  2 => 'htmlproofer found errors'
}

system 'bundle exec rake'

fail message if message = error_messages[$?.exitstatus]

commit_lint.check
