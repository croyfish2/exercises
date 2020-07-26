# Load the Rails application.
require_relative 'application'

Rails.application.config.credly_org_id = ENV['CREDLY_ORG_ID']
Rails.application.config.credly_api_key = ENV['CREDLY_API_KEY']

# Initialize the Rails application.
Rails.application.initialize!
