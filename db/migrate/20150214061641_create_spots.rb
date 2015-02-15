class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.string :point
    end
  end
end
