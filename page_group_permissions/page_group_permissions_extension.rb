# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

Page.module_eval do
  belongs_to :group
  
  def group_owners
    self.group.nil? ? [] : self.group.users
  end
end

User.module_eval do
  has_and_belongs_to_many :groups
end

Admin::PageController.module_eval do

  only_allow_access_to :new, :edit,
    :if => :user_is_in_page_group,
    :denied_url => { :controller => 'page', :action => 'index' },
    :denied_message => 'You must have group privileges to perform this action.'
  
  def user_is_in_page_group
    #return true if current_user.admin? || current_user.developer?
    
    page = Page.find(params[:id] || params[:parent_id])
    
    until page.parent.nil? do
      return true if page.group_owners.include? current_user
      page = page.parent
    end
    
    return false
  end
end

class PageGroupPermissionsExtension < Radiant::Extension
  version "0.1"
  description "Allows you to organize your users into groups and apply group based edit permissions to the page heirarchy."
  url "http://matt.freels.name"
  
define_routes do |map|
  map.connect 'admin/groups/:action', :controller => 'admin/groups'
end
  
  def activate
    admin.tabs.add "Groups", "/admin/groups", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    admin.tabs.remove "Groups"
  end
  
end