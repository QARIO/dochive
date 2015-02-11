class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.integer :document_id
      t.integer :template_id
      t.integer :page_id
      t.string :path
      t.string :url
      t.string :filename
      t.string :description
      t.boolean :public

      t.timestamps
    end
  end
end
