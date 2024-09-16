class VisitProp < ApplicationRecord
  include VisitPropValidatable

  belongs_to :checkpoint
  belongs_to :place, optional: true
  belongs_to :residence, optional: true
  belongs_to :spot, optional: true
end
