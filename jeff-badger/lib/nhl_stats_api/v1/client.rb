require 'faraday'
require 'oj'

module NHLStatsAPI
  module V1
    class Client
      API_BASE = 'https://statsapi.web.nhl.com/api/v1'.freeze

      def get_prospect_by_nhl_stats_prospect_id(nhl_stats_prospect_id)
        endpoint = "draft/prospects/#{nhl_stats_prospect_id}"
	make_request(:get, endpoint) 
      end

      private

      def client
        @_client ||= Faraday.new(API_BASE) do |client|
	  client.adapter Faraday.default_adapter
	  client.request :url_encoded
	  client.headers.merge(request_headers)
	end
      end
      
      def make_request(http_method, endpoint, params = {})
	response = client.public_send(http_method, endpoint, params)
	Oj.load(response.body)
      end

      def request_headers
        headers = {}
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers 
      end
    end
  end
end
     
     
