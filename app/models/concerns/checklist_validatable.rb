module ChecklistValidatable
  extend ActiveSupport::Concern
  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validates :recurrence, presence: { message: I18n.t("validations.common.recurrence_presence") }, if: -> { is_planned }
    validates :recurrence, absence: { message: I18n.t("validations.common.recurrence_absence") }, unless: -> { is_planned }
  end
end
