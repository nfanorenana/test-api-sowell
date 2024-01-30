class AgencyResource < ApplicationResource
  attribute :name, :string
  attribute :company_id, :integer, only: [:filterable]
  attribute :has_scheduled_visit, :boolean, only: [:filterable]

  belongs_to :company
  has_many :residences

  filter :has_scheduled_visit, :boolean, single: true do
    eq do |agencies, value|
      if value
        agencies.joins(residences: { places: :visit_schedules })
      else
        agencies.left_joins(residences: { places: :visit_schedules }).where(visit_schedules: { place_id: nil })
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
