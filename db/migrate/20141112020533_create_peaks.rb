class CreatePeaks < ActiveRecord::Migration
  def change
    create_table :peaks do |t|
      t.integer :page_id
      t.string :dimension
      t.integer :number
      t.integer :offset
      t.integer :intensity

      t.timestamps
    end
  end
end
