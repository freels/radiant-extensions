class GroupsController < ApplicationController
  def index
    @groups = Group.find :all
  end
end
