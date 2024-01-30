# frozen_string_literal: true

class SerializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_serializer_file
    template "serializer.rb", File.join("app/serializers/", class_path, "#{file_name}_serializer.rb")
    template "serializer_test.rb", File.join("test/serializers/", class_path, "#{file_name}_serializer_test.rb")
  end
end
