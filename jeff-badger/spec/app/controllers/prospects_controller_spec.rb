require_relative '../../rails_helper'
require_relative '../../../app/controllers/prospects_controller.rb'

RSpec.describe ProspectsController do

  describe "#create" do
    subject { ProspectsController.new().create }
    it "creates a prospect" do
      #puts subject["prospects"][0].inspect
       puts subject.inspect
    end
  end

end
