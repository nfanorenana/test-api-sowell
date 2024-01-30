# frozen_string_literal: true

class SectorResource < ApplicationResource
  attribute :name, :string
  attribute :code, :string
  attribute :company_id, :integer, only: [:filterable]
  attribute :updated_at, :datetime, only: %i[readable filterable]
  attribute :reporter_id, :string, only: [:filterable]
  extra_attribute :places_count, :integer, only: [:readable] do
    @object.places.count
  end

  belongs_to :company
  has_many :roles

  filter :reporter_id, :integer do
    eq do |scope, value|
      scope.by_user_role(:reporter, value)
    end
  end

  filter :agency_id, :integer do
    eq do |scope, value|
      scope.joins({ places: :residence }).where(residences: { agency_id: value })
    end
  end

  filter :residence_id, :integer do
    eq do |scope, value|
      scope.joins(:places).where(places: { residence_id: value })
    end
  end
end
