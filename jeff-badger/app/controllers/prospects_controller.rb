require_relative '../../lib/nhl_stats_api/v1/client.rb'

class ProspectsController < ApplicationController
  def index
    @prospects = Prospect.order('id desc').limit(5)
  end
end
