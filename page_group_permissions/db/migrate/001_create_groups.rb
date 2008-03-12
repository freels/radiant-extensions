class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name
      t.text :notes
      t.integer :created_by, :updated_by

      t.timestamps
    end
    
    create_table(:groups_users, :id => false) do |t|
      t.integer :group_id, :user_id
    end
    add_index :groups_users, [:group_id, :user_id]
    
    add_column :pages, :group_id, :integer
    
    #Add a default group to own the home page
    Group.reset_column_information
    Page.reset_column_information
    
    p = Page.find_by_parent_id(nil)
    p.group = Group.create(:name => 'Site Editors')
    p.save
  end

  def self.down
    remove_column :pages, :group_id
    drop_table :groups
    drop_table :groups_users
  end
end
