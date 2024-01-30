# frozen_string_literal: true

require "test_helper"

class SectorSerializerTest < ActionDispatch::IntegrationTest
  # TODO: Remove or replace

  # context '#get request' do
  #   setup do
  #     @user = create(:user, email: 'superadmin@email.com', company: nil)
  #     @user.add_role! :superadmin

  #     company = create(:company, id: 4321)
  #     @sector = create(:sector, id: 1234, company: company)
  #   end

  #   should 'provide serialized attributes' do
  #     get sector_url(@sector), headers: authorization_header(@user), as: :json

  #     data = JSON.parse(response.body)['data']
  #     assert_equal '1234', data['id']
  #     assert_equal 'sector', data['type']

  #     attributes = data['attributes']
  #     assert_equal 'fakeName', attributes['name']
  #     assert_equal 'fakeCode', attributes['code']
  #   end

  #   should 'provide serialized relationships' do
  #     get sector_url(@sector), headers: authorization_header(@user), as: :json

  #     data = JSON.parse(response.body)['data']

  #     relationships = data['relationships']
  #     refute_nil relationships['company']
  #     assert_equal '4321', relationships['company']['data']['id']

  #   end
  # end
end
