module SectorValidatable
  extend ActiveSupport::Concern
  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    # FIXME: Add index to sector name
    validates :name, uniqueness: { case_sensitive: false, scope: :company_id }
    validates :code, uniqueness: { case_sensitive: false, scope: :company_id }, unless: -> { code.blank? }
  end
end
