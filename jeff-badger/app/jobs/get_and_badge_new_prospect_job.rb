require 'nhl_stats_api'
require 'credly_api'

class GetAndBadgeNewProspectJob < ActiveJob::Base
  queue_as :default

  def perform
    new_prospect = next_prospect(next_nhl_stats_prospect_id)
    badge_template_id = badge_template_id_from_position(new_prospect.position)
    badge = credly.award_badge_to_prospect(new_prospect, badge_template_id)
    puts "badge: #{badge.inspect}"
  end

  def next_nhl_stats_prospect_id 
    (Prospect.maximum("nhl_stats_prospect_id") || 0) + 1
  end

  def next_prospect(next_id)
    prospect_data = next_prospect_data(next_id)
    create_params = prospect_create_params(prospect_data) 
    new_prospect = Prospect.new(create_params)
    new_prospect.save!
    new_prospect
  end

  def next_prospect_data(next_id)
    nhl_stats.get_prospect_by_nhl_stats_prospect_id(next_id)["prospects"][0]
  end

  def prospect_create_params(data)
    {
      :first_name => data['firstName'],
      :last_name => data['lastName'], 
      :position => data['primaryPosition']['code'],
      :nhl_stats_prospect_id => data['id']
    }
  end
 
  def badge_template_id_from_position(position)
    badge_templates.each do |template|
      return template["id"] if template["skills"].include?(skills_map[position])
    end  
  end

  def badge_templates
    credly.get_badge_templates["data"]
  end

  def skills_map
    {
      "R" => "Right Wing",
      "L" => "Left Wing",
      "C" => "Center",
      "D" => "Defenseman",
      "G" => "Goalie"
    }
  end

  def nhl_stats
    @nhl_stats ||= NHLStatsAPI::V1::Client.new()
  end

  def credly
    @credly ||= CredlyAPI::V1::Client.new()
  end
end
