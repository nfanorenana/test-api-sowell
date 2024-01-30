class AddLogoUrlToChecklists < ActiveRecord::Migration[7.0]
  def change
    add_column :checklists, :logo_url, :string
  end
end
