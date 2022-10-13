require "controllers/api/v1/test"

class Api::V1::PaymentsControllerTest < Api::Test
    def setup
      # See `test/controllers/api/test.rb` for common set up for API tests.
      super

      @payment = build(:payment, team: @team)
      @other_payments = create_list(:payment, 3)
      # 🚅 super scaffolding will insert file-related logic above this line.
      @payment.save

      @another_payment = create(:payment, team: @team)
    end

    # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
    # data we were previously providing to users _will_ break the test suite.
    def assert_proper_object_serialization(payment_data)
      # Fetch the payment in question and prepare to compare it's attributes.
      payment = Payment.find(payment_data["id"])

      assert_equal_or_nil payment_data['name'], payment.name
      assert_equal_or_nil payment_data['amount'], payment.amount
      # 🚅 super scaffolding will insert new fields above this line.

      assert_equal payment_data["team_id"], payment.team_id
    end

    test "index" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/teams/#{@team.id}/payments", params: {access_token: access_token}
      assert_response :success

      # Make sure it's returning our resources.
      payment_ids_returned = response.parsed_body.dig("data").map { |payment| payment["id"] }
      assert_includes(payment_ids_returned, @payment.id)

      # But not returning other people's resources.
      assert_not_includes(payment_ids_returned, @other_payments[0].id)

      # And that the object structure is correct.
      assert_proper_object_serialization response.parsed_body.dig("data").first
    end

    test "show" do
      # Fetch and ensure nothing is seriously broken.
      get "/api/v1/payments/#{@payment.id}", params: {access_token: access_token}
      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      get "/api/v1/payments/#{@payment.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "create" do
      # Use the serializer to generate a payload, but strip some attributes out.
      params = {access_token: access_token}
      payment_data = JSON.parse(build(:payment, team: nil).to_api_json)
      payment_data.except!("id", "team_id", "created_at", "updated_at")
      params[:payment] = payment_data

      post "/api/v1/teams/#{@team.id}/payments", params: params
      assert_response :success

      # # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # Also ensure we can't do that same action as another user.
      post "/api/v1/teams/#{@team.id}/payments",
        params: params.merge({access_token: another_access_token})
      assert_response :not_found
    end

    test "update" do
      # Post an attribute update ensure nothing is seriously broken.
      put "/api/v1/payments/#{@payment.id}", params: {
        access_token: access_token,
        payment: {
          name: 'Alternative String Value',
          amount: 'Alternative String Value',
          # 🚅 super scaffolding will also insert new fields above this line.
        }
      }

      assert_response :success

      # Ensure all the required data is returned properly.
      assert_proper_object_serialization response.parsed_body

      # But we have to manually assert the value was properly updated.
      @payment.reload
      assert_equal @payment.name, 'Alternative String Value'
      assert_equal @payment.amount, 'Alternative String Value'
      # 🚅 super scaffolding will additionally insert new fields above this line.

      # Also ensure we can't do that same action as another user.
      put "/api/v1/payments/#{@payment.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end

    test "destroy" do
      # Delete and ensure it actually went away.
      assert_difference("Payment.count", -1) do
        delete "/api/v1/payments/#{@payment.id}", params: {access_token: access_token}
        assert_response :success
      end

      # Also ensure we can't do that same action as another user.
      delete "/api/v1/payments/#{@another_payment.id}", params: {access_token: another_access_token}
      assert_response :not_found
    end
end
