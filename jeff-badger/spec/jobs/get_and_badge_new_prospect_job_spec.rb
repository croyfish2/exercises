require 'rails_helper'

RSpec.describe GetAndBadgeNewProspectJob, type: :job do
  include ActiveJob::TestHelper

  describe '#perform' do
    subject { GetAndBadgeNewProspectJob.new.perform }

    it 'generates the new prospect' do
      subject.inspect
    end
  end
end
