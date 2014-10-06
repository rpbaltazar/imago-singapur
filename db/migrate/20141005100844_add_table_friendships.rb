class AddTableFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :person_id
      t.integer :friend_person_id
    end
  end
end
