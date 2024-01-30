module IssueReportObserver
  extend ActiveSupport::Concern

  included do
    before_update :update_timestamps_status
  end

  private

  def update_timestamps_status
    self.pending_timestamp = created_at
    status_timestamp = status + "_timestamp"
    self[status_timestamp.to_sym] = updated_at

    self.done_timestamp =  self.canceled_timestamp = nil if status == "ongoing"

    self.ongoing_timestamp = self.done_timestamp = self.canceled_timestamp = nil if status == "pending"
  end
end
