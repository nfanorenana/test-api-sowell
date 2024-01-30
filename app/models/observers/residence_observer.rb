module ResidenceObserver
  extend ActiveSupport::Concern

  included do
    after_update :touch_places
  end

  private

  def touch_places
    places.each(&:touch)
  end
end
