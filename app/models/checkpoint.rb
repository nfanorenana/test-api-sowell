class Checkpoint < ApplicationRecord
  include CheckpointValidatable
  include CheckpointObserver

  belongs_to :checklist
  belongs_to :issue_type
end
