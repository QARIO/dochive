class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :user_id
      t.integer :phase_id
      t.string :description

      t.timestamps
    end
  end
end
