class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :nickname
      t.datetime :arrival_date
      t.string :sex
      t.datetime :exit_date
      t.datetime :birthday

      t.timestamps
    end
  end
end
