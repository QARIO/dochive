class Document < ActiveRecord::Base
  #attr_accessible :source
  #has_attached_file :source, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  belongs_to :user    

  has_many :data, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  has_many :phases

  has_attached_file :source,
                    :url  => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"


  #validates_attachment_content_type :source,
  #      :content_type => [ 'application/pdf' ],
  #      :message => "only pdf files are allowed"
end
