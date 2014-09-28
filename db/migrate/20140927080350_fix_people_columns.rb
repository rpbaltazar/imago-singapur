class FixPeopleColumns < ActiveRecord::Migration
  def change
    change_column :people, :current_sign_in_ip, :string
    change_column :people, :last_sign_in_ip, :string
  end
end
