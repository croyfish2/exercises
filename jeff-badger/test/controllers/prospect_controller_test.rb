require 'test_helper'

class ProspectControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get prospect_index_url
    assert_response :success
  end

end
