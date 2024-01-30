class PlaceResource < ApplicationResource
  attribute :name, :string
  attribute :zip, :string
  attribute :city, :string
  attribute :country, :string
  attribute :street_number, :integer
  attribute :street_name, :string
  attribute :residence_id, :integer, only: [:filterable]
  attribute :company_id, :integer, only: [:filterable]
  attribute :has_scheduled_visit, :boolean, only: [:filterable]
  attribute :updated_at, :datetime, only: %i[readable filterable]
  extra_attribute :sector_ids, :array, only: [:readable] do
    @object.sectors.pluck(:id)
  end

  on_extra_attribute :sector_ids do |scope|
    scope.includes(:sectors)
  end

  belongs_to :company
  belongs_to :residence
  has_many :spots
  has_many :visit_schedules

  filter :has_scheduled_visit, :boolean, single: true do
    eq do |places, value|
      if value
        places.joins(:visit_schedules)
      else
        places.left_joins(:visit_schedules).where(visit_schedules: { place_id: nil })
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

  filter :residence_id, :integer do
    eq do |scope, value|
      scope.where(residence_id: value )
    end
  end

  filter :agency_id, :integer do
    eq do |scope, value|
      scope.joins(:residence).where(residences: { agency_id: value })
    end
  end

  filter :sector_id, :integer do
    eq do |scope, value|
      scope.joins(:sectors).where(sectors: { id: value })
    end
  end

  filter :updated_since, :string, single: true do
    eq do |places, value|
      places.where("places.updated_at >= ?", DateTime.strptime(value, "%d-%m-%Y-%H-%M-%S"))
    end
  end

  filter :city, :string do
    eq do |places, value|
      places.where("places.city ILIKE ?", value)
    end
  end
  
  filter :excluded_sector, :string do
    eq do |places, value|
      scope_id = value.first.to_i
      excluded_places_ids = places.ids - Sector.find(scope_id).places.ids
      places.where(id: excluded_places_ids)
    end
  end
end
