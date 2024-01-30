# frozen_string_literal: true

module Serializable
  # TODO: Remove or replace
  # extend ActiveSupport::Concern

  # included do
  #   # include JSONAPI::Deserialization
  #   # before_action :validate_ressource_format!, only: %i[create update]
  #   # before_action :validate_ressource_attributes!, only: %i[create update]
  # end

  # private

  # # Only allow well formated jsonapi content
  # def validate_ressource_format!
  #   params.require(:data).require(:attributes).permit!
  # rescue StandardError => e
  #   raise Rescueable::UnprocessableEntity.new e.original_message.split('\n').first, 'Missing params'
  # end

  # # Only allow serializable attributes
  # def validate_ressource_attributes!
  #   differences = incoming_attributes_list - allowed_attributes_list
  #   return unless differences.present?

  #   raise Rescueable::UnprocessableEntity.new "The following params are unprocessable: #{differences.join(', ')}",
  #                                             'Unknown attributes'
  # end

  # def incoming_attributes_list
  #   params.require(:data).require(:attributes).permit!.to_h.keys.sort.map(&:to_sym)
  # end

  # def allowed_attributes_list
  #   "#{controller_name.singularize.camelize}Serializer".constantize.attributes_to_serialize.keys.sort
  # end
end
