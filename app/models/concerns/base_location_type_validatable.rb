module BaseLocationTypeValidatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validates :depth_level, presence: true, inclusion: { in: BaseLocationType.depth_levels.keys }
  end

end
