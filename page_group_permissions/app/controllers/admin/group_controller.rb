class Admin::GroupController < Admin::AbstractModelController
  model_class Group

  only_allow_access_to :add_page, :add_member, :remove_member, :new, :edit, :remove, :index,
  :when => [:admin],
  :denied_url => { :controller => 'page', :action => 'index' },
  :denied_message => 'You must have administrator privileges to perform this action.'

  def add_page
    page = Page.find params[:page_id]

    begin
      group = Group.find params[:group_id]
      page.group = group
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

  def add_member
    if request.post?
      @group = Group.find params[:id]
      @user = User.find params[:user_id]

      @group.users << @user
      @group.save
      flash[:notice] = "#{@user.name} added to #{@group.name}."
    end
  rescue ::ActiveRecord::RecordNotFound
    if @group.nil?
      flash[:error] = "Group not found for that id."
    elsif @user.nil?
      flash[:error] = "Please select a user to add to #{@group.name}."
    end
  ensure
    redirect_to :action => 'index'
  end

  def remove_member
    @group = Group.find params[:id]
    @user = User.find params[:user_id]
    
    if request.post?
      @group.users.delete @user
      @group.save
      flash[:notice] = "#{@user.name} removed from #{@group.name}."
      redirect_to :action => 'index'
    end
  rescue
    if @group.nil?
      flash[:error] = "Group not found for that group id."
    elsif @user.nil?
      flash[:error] = "User not found for that user id."
    end
    redirect_to :action => 'index'
  end
end
