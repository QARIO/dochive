class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :style_id
      t.integer :type_id
      t.string :name
      t.string :description
      t.string :path
      t.string :url
      t.string :filename
      t.integer :vpc
      t.integer :hpc
      t.integer :selfie

      t.timestamps
    end
  end
end
