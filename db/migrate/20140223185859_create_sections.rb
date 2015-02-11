class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :template_id
      t.string :name
      t.integer :yOrigin
      t.integer :xOrigin
      t.integer :width
      t.integer :height
      t.integer :yOriginView
      t.integer :xOriginView
      t.integer :widthView
      t.integer :heightView

      t.timestamps
    end
  end
end
