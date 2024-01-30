# frozen_string_literal: true

module Rescueable
  extend ActiveSupport::Concern

  class Unauthorized < StandardError
    def initialize(msg = I18n.t("errors.rescueable.unauthorized"), type = Rack::Utils::HTTP_STATUS_CODES[401])
      @type = type
      super(msg)
    end
    attr_reader :type
  end

  class UnprocessableEntity < StandardError
    def initialize(msg = I18n.t("errors.rescueable.unprocessable_entity"), type = Rack::Utils::HTTP_STATUS_CODES[422])
      @type = type
      super(msg)
    end
    attr_reader :type
  end

  class Forbidden < StandardError
    def initialize(msg = I18n.t("errors.rescueable.forbidden"), type = Rack::Utils::HTTP_STATUS_CODES[403])
      @type = type
      super(msg)
    end
    attr_reader :type
  end

  included do
    register_exception Rescueable::Unauthorized, status: 401, message: true, title: Rack::Utils::HTTP_STATUS_CODES[401]
    register_exception Rescueable::UnprocessableEntity, status: 422, message: true, title: Rack::Utils::HTTP_STATUS_CODES[422]
    register_exception Rescueable::Forbidden, status: 403, message: true, title: Rack::Utils::HTTP_STATUS_CODES[403]
    register_exception Graphiti::Errors::RecordNotFound, status: 404, message: true, title: Rack::Utils::HTTP_STATUS_CODES[404]
    register_exception ActionController::BadRequest, status: 400, message: true, title: Rack::Utils::HTTP_STATUS_CODES[400]
    register_exception CanCan::AccessDenied, status: 403, message: true, title: Rack::Utils::HTTP_STATUS_CODES[403]
    register_exception Graphiti::Errors::InvalidInclude, status: 400, message: true, title: Rack::Utils::HTTP_STATUS_CODES[400]
  end
end
