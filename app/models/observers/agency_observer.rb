module AgencyObserver
  extend ActiveSupport::Concern

  included do
    after_update :touch_places
  end

  private

  def touch_places
    residences.each do |residence|
      residence.places.each(&:touch)
    end
  end
end
