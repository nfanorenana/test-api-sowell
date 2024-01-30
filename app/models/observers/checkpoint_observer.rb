module CheckpointObserver
  extend ActiveSupport::Concern

  included do
    after_create :touch_checklist
    before_destroy :touch_checklist
  end

  private

  def touch_checklist
    checklist.touch
  end
end
