class AddAttachmentSourceToDocuments < ActiveRecord::Migration
  def self.up
    change_table :documents do |t|
      t.attachment :source
    end
  end

  def self.down
    drop_attached_file :documents, :source
  end
end
