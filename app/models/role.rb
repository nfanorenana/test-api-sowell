# frozen_string_literal: true

class Role < ApplicationRecord
  extend Enumerize

  belongs_to :user, counter_cache: true
  belongs_to :sector, optional: true

  enum :name, { reporter: 1, checklister: 2, manager: 3, admin: 4, superadmin: 5 }

  include RoleValidatable
end
