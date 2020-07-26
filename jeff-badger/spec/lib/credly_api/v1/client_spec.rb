require_relative '../../../rails_helper'
require_relative '../../../../lib/credly_api/v1/client.rb'

RSpec.describe CredlyAPI::V1::Client do

  describe "#award_badge" do
    subject { CredlyAPI::V1::Client.new().award_badge_to_prospect('fake_id') }
    it "awards the badge" do
      #puts subject.inspect
    end
  end

  describe "#get_badge_templates" do
    subject { CredlyAPI::V1::Client.new().get_badge_templates }
    it "gets the templates" do
      #puts subject.inspect
    end
  end
end
