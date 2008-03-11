class Group < ActiveRecord::Base
  
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by'
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  has_and_belongs_to_many :users
  has_many :pages

end
