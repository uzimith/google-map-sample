class AddCounter < ActiveRecord::Migration
  def change
    add_column :spots, :comments_count, :integer, default: 0
  end
end
