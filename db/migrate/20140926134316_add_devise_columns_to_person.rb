class AddDeviseColumnsToPerson < ActiveRecord::Migration
  def change
    change_table :people do |t|
      ##Database auth
      t.string :email, :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => '', :limit => 128
      #recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      #rememberable
      t.datetime :remember_created_at
      #trackable
      t.integer :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.datetime :current_sign_in_ip
      t.datetime :last_sign_in_ip
    end
  end
end
