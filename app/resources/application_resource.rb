# frozen_string_literal: true

class ApplicationResource < Graphiti::Resource
  self.abstract_class = true
  self.adapter = Graphiti::Adapters::ActiveRecord

  # Retrieves current_ability from context, which is an instance of the controller
  delegate :current_user, to: :context

  before_save do |model|
    authorize_create_or_update(model) if local_model_is_subject?
  end

  before_destroy do |model|
    authorize :destroy, model unless model.id.nil? || !local_model_is_subject?
  end

  def base_scope
    if local_model_is_subject?
      model.accessible_by(current_ability)
    else
      super
    end
  end

  def authorize_from_resource_proxy(method, resource_proxy)
    # Converts Graphiti::ResourceProxy instance into an ActiveRecord::Relation instance
    resource = resource_proxy.scope.object.first
    authorize(method, resource)
  end

  def authorize(method, resource)
    raise CanCan::AccessDenied.new("Not authorized!", method, resource) unless current_ability.can?(method, resource)
  end

  private

  def authorize_create_or_update(model)
    if model.id.nil?
      authorize :create, model
    else
      authorize :update, model
    end
  end

  def local_model_is_subject?
    # The model directly related to the calling controller
    subject_model = context.controller_name.classify.constantize

    # The model that is currently calling the base_scope method
    local_model = model
    subject_model == local_model
  end

  def current_ability
    ability_class = self.class.name.gsub("Resource", "Ability").constantize
    ability_class.new(current_user)
  end
end
