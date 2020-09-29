# frozen_string_literal: true

error_messages = {
  1 => 'Middleman failed to build site',
  2 => 'htmlproofer found errors'
}

system 'bundle exec rake'

message = error_messages[$CHILD_STATUS.exitstatus]
raise message if message

commit_lint.check
