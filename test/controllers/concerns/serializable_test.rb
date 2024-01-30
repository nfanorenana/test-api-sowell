# frozen_string_literal: true

require "test_helper"

class SerializableTest < ActionDispatch::IntegrationTest
  # TODO: Remove or replace

  # context 'validate_ressource_format! before_action' do
  #   setup do
  #     @user = create(:user, email: 'superadmin@email.com', company: nil)
  #     @user.add_role! :superadmin
  #   end

  #   should 'succeed with expected params' do
  #     post users_url,
  #          headers: authorization_header(@user),
  #          params: {
  #            data: {
  #              attributes: {
  #                email: 'user@email.com', fname: 'fname', lname: 'lname', password: '123456'
  #              }
  #            }
  #          }, as: :json
  #     assert_equal '201', response.code
  #   end

  #   should 'fail if attributes param is missing' do
  #     post users_url,
  #          headers: authorization_header(@user),
  #          params: {
  #            data: {
  #              email: 'user@email.com', fname: 'fname', lname: 'lname', password: '123456'
  #            }
  #          }, as: :json
  #     assert_equal '422', response.code
  #     assert_equal 'Missing params', JSON.parse(response.body)['errors'].first['title']
  #   end

  #   should 'fail if data param is missing' do
  #     post users_url,
  #          headers: authorization_header(@user),
  #          params: {
  #            attributes: {
  #              email: 'user@email.com', fname: 'fname', lname: 'lname', password: '123456'
  #            }
  #          }, as: :json
  #     assert_equal '422', response.code
  #     assert_equal 'Missing params', JSON.parse(response.body)['errors'].first['title']
  #   end
  # end

  # context 'validate_ressource_attributes! before_action' do
  #   setup do
  #     @user = create(:user, email: 'superadmin@email.com', company: nil)
  #     @user.add_role! :superadmin
  #   end

  #   should 'fail with unknown attributtes' do
  #     post users_url,
  #          headers: authorization_header(@user),
  #          params: {
  #            data: {
  #              attributes: {
  #                unknown: 'attribute', email: 'user@email.com', fname: 'fname', lname: 'lname', password: '123456'
  #              }
  #            }
  #          }, as: :json
  #     assert_equal '422', response.code
  #     assert_equal 'Unknown attributes', JSON.parse(response.body)['errors'].first['title']
  #   end
  # end
end
