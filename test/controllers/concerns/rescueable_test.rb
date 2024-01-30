# frozen_string_literal: true

require "test_helper"

class RescueableTest < ActionDispatch::IntegrationTest
  # FIXME: Fix according to changes in rescueable concern

  #   setup do
  #     def with_fake_routing
  #       Rails.application.routes.draw do
  #         get '/fake_unprocessable_entity' => 'fake#fake_unprocessable_entity_raiser'
  #         get '/fake_unauthorized_raiser' => 'fake#unauthorized_raiser'
  #         get '/fake_not_found' => 'fake#not_found_raiser'
  #         get '/fake_bad_request' => 'fake#bad_request_raiser'
  #         get '/fake_access_denied' => 'fake#access_denied_raiser'
  #       end
  #       yield
  #     ensure
  #       Rails.application.routes_reloader.reload!
  #     end
  #   end

  #   context 'rescue_from Rescueable::UnprocessableEntity' do
  #     should 'handle a unprocessable error' do
  #       with_fake_routing do
  #         get '/fake_unprocessable_entity'
  #         rendered_error = JSON.parse(response.body)['errors'].first
  #         assert_equal 422, rendered_error['status']
  #         assert_equal 'Unprocessable Entity', rendered_error['title']
  #         assert_equal I18n.t('errors.rescueable.unprocessable_entity'), rendered_error['detail']
  #       end
  #     end
  #   end

  #   context 'rescue_from Rescueable::Unauthorized' do
  #     should 'handle unauthorized error' do
  #       with_fake_routing do
  #         get '/fake_unauthorized_raiser'
  #         rendered_error = JSON.parse(response.body)['errors'].first
  #         assert_equal 401, rendered_error['status']
  #         assert_equal 'Unauthorized', rendered_error['title']
  #         assert_equal I18n.t('errors.rescueable.unauthorized'), rendered_error['detail']
  #       end
  #     end
  #   end

  #   context 'rescue_from ActiveRecord::RecordNotFound' do
  #     should 'handle not found error' do
  #       with_fake_routing do
  #         # With default message
  #         get '/fake_not_found'
  #         rendered_error = JSON.parse(response.body)['errors'].first
  #         assert_equal 404, rendered_error['status']
  #         assert_equal 'Not Found', rendered_error['title']
  #         assert_equal 'La resource demandée est introuvable', rendered_error['detail']

  #         # With custom message on raise
  #         get '/fake_not_found?message=custom_error'
  #         rendered_error = JSON.parse(response.body)['errors'].first
  #         assert_equal 404, rendered_error['status']
  #         assert_equal 'Not Found', rendered_error['title']
  #         assert_equal 'custom_error', rendered_error['detail']
  #       end
  #     end
  #   end

  #   context 'rescue_from ActionController::BadRequest' do
  #     should 'handle bad request error' do
  #       with_fake_routing do
  #         # With default message
  #         get '/fake_bad_request'
  #         rendered_error = JSON.parse(response.body)['errors'].first
  #         assert_equal 400, rendered_error['status']
  #         assert_equal 'Bad Request', rendered_error['title']
  #         assert_equal 'La requête est incorrecte/incompréhensible', rendered_error['detail']

  #         # With custom message on raise
  #         get '/fake_bad_request?message=custom_error'
  #         rendered_error = JSON.parse(response.body)['errors'].first
  #         assert_equal 400, rendered_error['status']
  #         assert_equal 'Bad Request', rendered_error['title']
  #         assert_equal 'custom_error', rendered_error['detail']
  #       end
  #     end
  #   end

  #   context 'rescue_from CanCan::AccessDenied' do
  #     should 'handle access denied error' do
  #       with_fake_routing do
  #         # With default message
  #         get '/fake_access_denied'
  #         rendered_error = JSON.parse(response.body)['errors'].first
  #         assert_equal 403, rendered_error['status']
  #         assert_equal 'Forbidden', rendered_error['title']
  #         assert_equal "L'utilisateur est reconnu mais ne peut pas réaliser cette action", rendered_error['detail']

  #         # With custom message on raise
  #         get '/fake_access_denied?message=custom_error'
  #         rendered_error = JSON.parse(response.body)['errors'].first
  #         assert_equal 403, rendered_error['status']
  #         assert_equal 'Forbidden', rendered_error['title']
  #         assert_equal 'custom_error', rendered_error['detail']
  #       end
  #     end
  #   end
  # end

  # class FakeController < ActionController::API
  #   include Tokenable
  #   include Serializable
  #   include Rescueable
  #   skip_before_action :set_user_from_token!
  #   skip_authorization_check
  #   load_and_authorize_resource except: %i[fake_unprocessable_entity_raiser unauthorized_raiser not_found_raiser
  #                                          access_denied_raiser bad_request_raiser]

  #   def fake_unprocessable_entity_raiser
  #     raise Rescueable::UnprocessableEntity
  #   end

  #   def unauthorized_raiser
  #     raise Rescueable::Unauthorized
  #   end

  #   def not_found_raiser
  #     raise ActiveRecord::RecordNotFound, custom_message
  #   end

  #   def access_denied_raiser
  #     raise CanCan::AccessDenied, custom_message
  #   end

  #   def bad_request_raiser
  #     raise ActionController::BadRequest, custom_message
  #   end

  #   private

  #   def custom_message
  #     # NOTE: In real use case, the custom error message is NOT passed as parameter
  #     # but directly set in the raise call
  #     request.params['message']
  #   end
end
