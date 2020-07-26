require_relative '../../../rails_helper'
require_relative '../../../../lib/nhl_stats_api/v1/client.rb'

RSpec.describe NHLStatsAPI::V1::Client do

  describe "#get_prospect_by_nhl_stats_prospect_id" do
    subject { NHLStatsAPI::V1::Client.new().get_prospect_by_nhl_stats_prospect_id(test_id) }
    let(:test_id) { 1 }
    it "#gets the prospect for the provided nhl stats prospect id" do
      puts subject["prospects"][0].inspect
    end
  end

end
