class CustomResourceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_ability_files
    template "custom_resource.rb", File.join("app/resources/", class_path, "#{file_name}_resource.rb")
  end
end
