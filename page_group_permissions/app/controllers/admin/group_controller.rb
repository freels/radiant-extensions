class Admin::GroupController < Admin::AbstractModelController
  model_class Group
  
  only_allow_access_to :add_page,
    :when => [:admin],
    :denied_url => { :controller => 'group', :action => 'index' },
    :denied_message => 'You must have administrator privileges to perform this action.'
  
  def add_page
    page = Page.find params[:page_id]

    begin
      group = Group.find params[:group_id]
      page.group
      page.save
      flash[:notice] = "Group for \"#{page.title}\" set to #{group.name}."

    rescue ::ActiveRecord::RecordNotFound
      page.group = nil
      page.save
      flash[:notice] = "Group removed from \"#{page.title}\"."

    ensure
      redirect_to :controller => 'admin/page', :action => 'index'
    end
  end
end
