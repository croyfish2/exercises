require 'faraday'
require 'oj'

module CredlyAPI
  module V1
    class Client
      API_BASE = 'https://sandbox-api.youracclaim.com/v1'.freeze
      ORG_ID = Rails.application.config.credly_org_id.freeze

      def award_badge_to_prospect(prospect, badge_template_id)
        endpoint = "organizations/#{ORG_ID}/badges"
     
        request_params = {
          :badge_template_id => badge_template_id,
          :issued_at => Time.now(),
	  :issued_to_first_name => prospect.first_name,
	  :issued_to_last_name => prospect.last_name,
	  :recipient_email => prospect.email,
	  :issuer_earner_id => prospect.id
	}
    
	make_request(:post, endpoint, request_params)
      end
    
      def get_badge_templates
        endpoint = "organizations/#{ORG_ID}/badge_templates"
	make_request(:get, endpoint) 
      end
      
      def get_badges_for_prospect(prospect_id)
        endpoint = "organizations/#{ORG_ID}/badges"#?filter=issue_earner_id::#{prospect_id}"
	params = { :filter => "issuer_earner_id::#{prospect_id}" }
	make_request(:get, endpoint, params)
      end

      private

      def client
        @_client ||= Faraday.new(API_BASE) do |client|
	  client.adapter Faraday.default_adapter
	  client.request :url_encoded
	  client.basic_auth *request_basic_auth
	  client.headers.merge(request_headers)
	end
      end
      
      def make_request(http_method, endpoint, params = {})
	response = client.public_send(http_method, endpoint, params)
	Oj.load(response.body)
      end

      def request_basic_auth
        [Rails.application.config.credly_api_key, '']
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
     
     
