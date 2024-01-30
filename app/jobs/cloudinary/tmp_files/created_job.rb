class Cloudinary::TmpFiles::CreatedJob < ActiveJob::Base
  retry_on Exception, wait: :exponentially_longer, attempts: 5

  def perform(id, folder)
    tmp_file = TmpFile.find(id)
    file_url = upload_file_to_cloudinary(tmp_file, folder)
    ActiveRecord::Base.connection_pool.with_connection do
      issue_report = IssueReport.find(tmp_file.resource_id)
      imgs = issue_report.imgs || []
      imgs << file_url
      issue_report.update!(imgs: imgs)
      tmp_file.destroy
    end
  end

  private

  def upload_file_to_cloudinary(tmp_file, folder)
    file_path = "tmp/#{tmp_file.filename}"
    File.binwrite(file_path, tmp_file.file_data)

    begin
      uploader = Cloudinary::Uploader.upload(file_path, public_id: "#{folder}/#{tmp_file.filename}",
                                                        overwrite: true)
      url = uploader["secure_url"]
      url
    rescue CloudinaryException => e
      puts "Error uploading file: #{e.message}"
    ensure
      File.delete(file_path)
    end
  end
end
