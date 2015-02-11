class Page < ActiveRecord::Base
  belongs_to :user  
  belongs_to :document  
  has_many :assets, :dependent => :destroy
  has_many :peaks, :dependent => :destroy
  #has_many :templates
end
