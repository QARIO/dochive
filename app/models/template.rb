class Template < ActiveRecord::Base
  has_many :sections, :dependent => :destroy
  has_many :markers, :dependent => :destroy
  #belobgs_to :page
end
