require_relative "lib/user_data_grouper"

args = ARGV

UserDataGrouper.new(*args)

puts "Your grouping is complete! Look in the files/output/ directory for the generated csv file."
