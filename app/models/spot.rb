class Spot < ApplicationRecord
  include SpotValidatable
  include SpotObserver

  belongs_to :place
  belongs_to :location_type
end
