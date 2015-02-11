class CreateMarkers < ActiveRecord::Migration
  def change
    create_table :markers do |t|
      t.integer :template_id
      t.string :dimension
      t.integer :number
      t.integer :offset
      t.integer :intensity

      t.timestamps
    end
  end
end
