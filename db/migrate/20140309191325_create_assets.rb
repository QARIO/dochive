class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.integer :document_id
      t.integer :page_id
      t.integer :section_id
      t.string :path
      t.string :url
      t.string :filename
      t.string :tpath
      t.string :turl
      t.string :tfilename
      t.string :language
      t.text :value

      t.timestamps
    end
  end
end
