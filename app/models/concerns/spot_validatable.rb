module SpotValidatable
  extend ActiveSupport::Concern
  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validate :place_and_location_type_are_from_same_company
  end

  private

  def place_and_location_type_are_from_same_company
    return if place&.company_id == location_type&.company_id

    errors.add(:place,
               I18n.t("validations.common.belonging_to_company"))
  end
end
