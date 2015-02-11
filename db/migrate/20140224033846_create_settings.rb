class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :user_id
      t.integer :default_template
      t.integer :default_language
      t.string :default_notification
      t.boolean :notify_complete
      t.integer :trimLeft
      t.integer :trimRight
      t.integer :trimTop
      t.integer :trimBottom

      t.timestamps
    end
  end
end
