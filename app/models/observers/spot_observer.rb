module SpotObserver
  extend ActiveSupport::Concern

  included do
    after_create :touch_place
    before_destroy :touch_place
  end

  private

  def touch_place
    place.touch
  end
end
