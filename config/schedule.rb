# require 'whenever'

# Use this file to easily define all of your cron jobs.
#
# set :environment, "development"
# set :output, {:error => "log/error.log", :standard => "log/cron.log"}

# It's helpful, but not entirely necessary to understand cron before proceeding.
every 1.minute do
  rake "map"

end

# http://en.wikipedia.org/wiki/Cron
# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
