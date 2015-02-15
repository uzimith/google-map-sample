class AddSpotImage < ActiveRecord::Migration
  def change
    add_column :spots, :image, :binary, limit: 10 * 1024 * 1024 # megabytes
    add_column :spots, :image_name, :string
    add_column :spots, :image_content_type, :string
  end
end
