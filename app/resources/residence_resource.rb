class ResidenceResource < ApplicationResource
  attribute :name, :string
  attribute :agency_id, :integer, only: [:filterable]
  attribute :company_id, :integer, only: [:filterable]
  attribute :has_scheduled_visit, :boolean, only: [:filterable]
  attribute :reporter_id, :string, only: [:filterable]

  belongs_to :company
  belongs_to :agency

  filter :has_scheduled_visit, :boolean, single: true do
    eq do |residences, value|
      if value
        residences.joins(places: :visit_schedules)
      else
        residences.left_joins(places: :visit_schedules).where(visit_schedules: { place_id: nil })
      end
    end
  end

  filter :reporter_id, :integer do
    eq do |scope, value|
      scope.by_user_role(:reporter, value)
    end
  end

  filter :manager_id, :integer do
    eq do |scope, value|
      scope.by_user_role(:manager, value)
    end
  end
end
