require 'credly_api'

class Prospect < ApplicationRecord

  #We don't have access to the prospects' real email addresses. If real, we'd need to
  #either store them in the db or be able to request them from some api endpoint on demand.
  #If stored in the db, we might consider encrypting them with salt.
  #
  def email
    "#{first_name}_#{last_name}_#{nhl_stats_prospect_id}@example.com"
  end

  def badge_image_url
    credly.get_badges_for_prospect(id)["data"][0]["image_url"]
  end

  def credly
    @credly ||= CredlyAPI::V1::Client.new()
  end
end
