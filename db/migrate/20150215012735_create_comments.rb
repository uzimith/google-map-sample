class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :name
      t.string :text
      t.references :spot
      t.timestamps
    end
  end
end
