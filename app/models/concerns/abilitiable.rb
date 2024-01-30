# frozen_string_literal: true

module Abilitiable
  extend ActiveSupport::Concern

  # NOTE: Cancancan helpers for User model
  def can?(action, subject, args = nil)
    ability(subject).can?(action, subject, args)
  end

  def cannot?(action, subject, args = nil)
    ability(subject).cannot?(action, subject, args)
  end

  private

  def ability(subject)
    "#{subject.model_name}Ability".constantize.new(self)
  end
end
