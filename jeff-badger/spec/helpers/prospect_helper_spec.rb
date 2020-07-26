require_relative "../rails_helper"
require 'json'

RSpec.describe ProspectHelper do

  describe "#get_prospects" do
    subject { get_prospects }
    it "gets the prospects" do
      #subject
    end
  end

  describe "award_gretzky_badge" do
    subject { award_badge('fake_id') }
    it "awards the badge" do
      #puts subject.body.inspect
    end
  end

  describe "get_badge_templates" do
    subject { get_badge_templates }
    it "gets the templates" do
      #puts JSON.parse(subject.body).inspect
      puts subject.inspect
    end
  end
end
