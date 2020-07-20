require_relative "lib/user_data_grouper"

abort "ERROR: You are running the Grouping application on an unsupported version of Ruby (Ruby #{RUBY_VERSION} #{RUBY_RELEASE_DATE})! Please upgrade to at least Ruby v2.6.1" if RUBY_VERSION < "2.6.1"

args = ARGV

UserDataGrouper.new(*args)

puts "Your grouping is complete! Look in the files/output/ directory for the generated csv file."
