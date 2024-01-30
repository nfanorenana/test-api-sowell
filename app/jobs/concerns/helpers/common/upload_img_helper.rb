module Helpers::Common::UploadImgHelper
  extend ActiveSupport::Concern

  def upload_img_to_cloudinary(img,folder,filename)
    # find file type
    type_match = /(png|jpg|jpeg|gif)/.match(img[0, 16].to_s.downcase)
    
    if type_match.present?
      filetype = type_match[0]
      base_64_code = img.gsub("data:image/#{filetype};base64,", '')
      # decode64
      img_from_base64 = Base64.decode64(base_64_code)
      file_path = 'tmp/' + filename
      # write file
      File.open(file_path, 'wb') do |f|
        f.write(img_from_base64)
      end
      uploader = Cloudinary::Uploader.upload(file_path, public_id: "#{folder}/#{filename}", :overwrite => true)
      url = uploader['secure_url']
      url
    else
      raise "not a valid image"
    end
  end
end