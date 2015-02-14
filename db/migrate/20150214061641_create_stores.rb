class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.string :point
    end
  end
end
