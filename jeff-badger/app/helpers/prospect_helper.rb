require 'faraday'
require 'json'

module ProspectHelper
  def get_prospects
    response = Faraday.get 'https://statsapi.web.nhl.com/api/v1/draft/2019'
  end

  def award_badge(badge_template_id)
    base_url = 'https://sandbox-api.youracclaim.com'
    endpoint = '/v1/organizations/6d13358f-2665-4b24-a570-191016e344b2/badges'

    body = {}
    body[:badge_template_id] = '8f1da830-a598-47cb-a9f3-d59cc095fe5a'
    body[:issued_at] = Time.now()
    body[:issued_to_first_name] = "Wayne"
    body[:issued_to_last_name] = "Gretzky"
    body[:recipient_email] = "wayne_gretzky@example.com"
    json_body = body.to_json

    headers = {}
    headers["Content-Type"] = "application/json"
    headers["Accept"] = "application/json"

    conn = Faraday.new base_url
    conn.basic_auth('NeuxxovB7mi5SwK3uA6fNpaENA0THVRsZhFA', '')

    response = conn.post(endpoint, json_body, headers) 
  end

  def get_badge_templates
    base_url = 'https://sandbox-api.youracclaim.com'
    endpoint = '/v1/organizations/6d13358f-2665-4b24-a570-191016e344b2/badge_templates'

    headers = {}
    headers["Content-Type"] = "application/json"
    headers["Accept"] = "application/json"

    conn = Faraday.new base_url
    conn.basic_auth('NeuxxovB7mi5SwK3uA6fNpaENA0THVRsZhFA', '')
    
    puts "Here's my conn: #{conn.inspect}"

    response = conn.get(endpoint, headers) 
    badge_templates = JSON.parse(response.body)
  end

end
