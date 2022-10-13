require "controllers/api/v1/test"

class Api::V1::ClientsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @client = build(:client, team: @team)
      @other_clients = create_list(:client, 3)
      # 🚅 super scaffolding will insert file-related logic above this line.
      @client.save

      @another_client = create(:client, team: @team)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(client_data)
      # Fetch the client in question and prepare to compare it's attributes.
      client = Client.find(client_data["id"])

      assert_equal_or_nil client_data['team_id'], client.team_id
      assert_equal_or_nil client_data['client_team_id'], client.client_team_id
      assert_equal_or_nil client_data['role_ids'], client.role_ids
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal client_data["team_id"], client.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/clients", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      client_ids_returned = response.parsed_body.dig("data").map { |client| client["id"] }
      assert_includes(client_ids_returned, @client.id)

      # But not returning other people's resources.
      assert_not_includes(client_ids_returned, @other_clients[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/clients/#{@client.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/clients/#{@client.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      client_data = JSON.parse(build(:client, team: nil).to_api_json)
      client_data.except!("id", "team_id", "created_at", "updated_at")
      params[:client] = client_data

      post "/api/v1/teams/#{@team.id}/clients", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/clients",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/clients/#{@client.id}", params: {
        access_token: access_token,
        client: {
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @client.reload
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/clients/#{@client.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Client.count", -1) do
        delete "/api/v1/clients/#{@client.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/clients/#{@another_client.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
