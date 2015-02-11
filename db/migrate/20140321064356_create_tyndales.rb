class CreateTyndales < ActiveRecord::Migration
  def change
    create_table :tyndales do |t|
      t.string :full
      t.string :short
      t.boolean :enabled

      t.timestamps
    end
  end
end
