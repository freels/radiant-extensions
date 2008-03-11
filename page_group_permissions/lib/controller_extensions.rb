PageControllerExtensions = Proc.new do
  only_allow_access_to :new, :edit,
    :if => :user_is_in_page_group,
    :denied_url => { :controller => 'page', :action => 'index' },
    :denied_message => 'You must have group privileges to perform this action.'
  
  def user_is_in_page_group
    return true if current_user.admin? || current_user.developer?
    
    page = Page.find(params[:id] || params[:parent_id])
    
    until page.parent.nil? do
      return true if page.group_owners.include? current_user
      page = page.parent
    end
    
    return false
  end
end
