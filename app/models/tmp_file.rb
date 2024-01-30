class TmpFile < ApplicationRecord
  include TmpFileValidatable
  include TmpFileObserver
end
  