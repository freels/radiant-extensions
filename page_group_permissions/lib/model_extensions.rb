PageModelExtensions = Proc.new do
  belongs_to :group
  
  def group_owners
    self.group.nil? ? [] : self.group.users
  end
  
  def group_name
    self.group.nil? ? '' : self.group.name
  end
end

UserModelExtensions = Proc.new do
  has_and_belongs_to_many :groups
end
