module TmpFileValidatable
  extend ActiveSupport::Concern
  included do
    validates :resource_id, presence: { message: I18n.t("validations.tmp_file.resource_id_presence") }
    validates :resource_type, presence: { message: I18n.t("validations.tmp_file.resource_type_presence") }
    validates :file_data, presence: { message: I18n.t("validations.tmp_file.file_data_presence") }
    validates :filename, presence: { message: I18n.t("validations.tmp_file.filename_presence") }
  end
end
