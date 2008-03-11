class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end
    
    create_table(:groups_users, :id => false) do |t|
      t.integer :group_id, :user_id
    end
    add_index :groups_users, [:group_id, :user_id]
    
    add_column :pages, :group_id, :integer
    add_column :users, :group_id, :integer
  end

  def self.down
    remove_column :pages, :group_id
    remove_column :users, :group_id
    drop_table :groups
    drop_table :groups_users
  end
end
