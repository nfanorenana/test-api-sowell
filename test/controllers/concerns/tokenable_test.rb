# frozen_string_literal: true

require "test_helper"
require "json_web_token"

class TokenableTest < ActionDispatch::IntegrationTest
  setup do
    @company = create(:company)
    @user = create(:user, email: "superadmin@email.com", company: @company)
    @payload = { uid: @user.id }
  end

  context "set_user_from_token! before_action" do
    should "accept a valid token" do
      token = JsonWebToken.encode(@payload)
      get "/users",
          headers: { Authorization: "Bearer #{token}" }
      assert_equal "200", response.code
    end

    should "reject a missing token" do
      get "/users",
          headers: { Authorization: "" }
      assert_equal "401", response.code

      get "/users"
      assert_equal "401", response.code
    end

    should "reject a token encoded with a bad secret" do
      @payload[:exp] = 7.days.from_now.to_i
      token = JWT.encode(@payload, "bad_secret", "HS256")
      get "/users",
          headers: { Authorization: "Bearer #{token}" }
      assert_equal "401", response.code
    end

    should "reject an expired token" do
      token = JsonWebToken.encode(@payload)
      travel_to 8.days.from_now do
        get "/users", headers: { Authorization: "Bearer #{token}" }
        assert_equal "401", response.code
      end
    end
  end

  context "#generate_token" do
    should "return a valid token" do
      stub = Class.new do
        extend(Tokenable)
        def self.gen_token(user)
          generate_token({ uid: user.id })
        end
      end

      token = stub.gen_token(@user)
      assert JsonWebToken.decode(token)["uid"], @user.id
    end
  end
end
