class ApplicationJob < ActiveJob::Base
  # Automatically retry workers that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most workers are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
