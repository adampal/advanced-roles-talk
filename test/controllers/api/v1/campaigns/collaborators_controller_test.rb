require "controllers/api/v1/test"

class Api::V1::Campaigns::CollaboratorsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @campaign = create(:campaign, team: @team)
@collaborator = build(:campaigns_collaborator, campaign: @campaign)
      @other_collaborators = create_list(:campaigns_collaborator, 3)
      # 🚅 super scaffolding will insert file-related logic above this line.
      @collaborator.save

      @another_collaborator = create(:campaigns_collaborator, campaign: @campaign)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(collaborator_data)
      # Fetch the collaborator in question and prepare to compare it's attributes.
      collaborator = Campaigns::Collaborator.find(collaborator_data["id"])

      assert_equal_or_nil collaborator_data['campaign_id'], collaborator.campaign_id
      assert_equal_or_nil collaborator_data['user_id'], collaborator.user_id
      assert_equal_or_nil collaborator_data['role_ids'], collaborator.role_ids
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal collaborator_data["campaign_id"], collaborator.campaign_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/campaigns/#{@campaign.id}/collaborators", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      collaborator_ids_returned = response.parsed_body.dig("data").map { |collaborator| collaborator["id"] }
      assert_includes(collaborator_ids_returned, @collaborator.id)

      # But not returning other people's resources.
      assert_not_includes(collaborator_ids_returned, @other_collaborators[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/campaigns/collaborators/#{@collaborator.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/campaigns/collaborators/#{@collaborator.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      collaborator_data = JSON.parse(build(:campaigns_collaborator, campaign: nil).to_api_json)
      collaborator_data.except!("id", "campaign_id", "created_at", "updated_at")
      params[:campaigns_collaborator] = collaborator_data

      post "/api/v1/campaigns/#{@campaign.id}/collaborators", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/campaigns/#{@campaign.id}/collaborators",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/campaigns/collaborators/#{@collaborator.id}", params: {
        access_token: access_token,
        campaigns_collaborator: {
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @collaborator.reload
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/campaigns/collaborators/#{@collaborator.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Campaigns::Collaborator.count", -1) do
        delete "/api/v1/campaigns/collaborators/#{@collaborator.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/campaigns/collaborators/#{@another_collaborator.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
