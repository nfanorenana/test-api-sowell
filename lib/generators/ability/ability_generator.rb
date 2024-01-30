# frozen_string_literal: true

class AbilityGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_ability_files
    template "ability.rb", File.join("app/abilities/", class_path, "#{file_name}_ability.rb")
    template "ability_spec.rb", File.join("test/abilities/", class_path, "#{file_name}_ability_spec.rb")
  end
end
