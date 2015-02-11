class User < ActiveRecord::Base 
#class User::ParameterSanitizer < Devise::ParameterSanitizer

    #end
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :groups, :dependent => :destroy
  has_many :templates, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  has_one :setting, :dependent => :destroy
  
end
