module Helpers
  def authorization_header(user)
    return unless user

    token = JsonWebToken.encode({ uid: user.id })

    {
          Authorization: "Bearer #{token}",
        }
  end

  def body_as_json
    Oj.load response.body
  end

  def upload_file(file_name, content_type = "image/*")
    file_path = Rails.root.join("spec", "fixtures", file_name)
    Rack::Test::UploadedFile.new(file_path, content_type)
  end
end
