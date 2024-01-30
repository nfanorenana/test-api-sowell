module TmpFileObserver
  extend ActiveSupport::Concern

  included do
    after_create :upload_file
  end

  private

  def upload_file
    case resource_type
    when "IssueReport"
      Cloudinary::TmpFiles::CreatedJob.perform_later(id, "ii_v2")
    else
      raise "not implemented resource_type"
    end
  end
end
