module PlaceObserver
  extend ActiveSupport::Concern

  included do
    before_destroy :touch_sectors
  end

  private

  def touch_sectors
    sectors.each(&:touch)
  end
end
