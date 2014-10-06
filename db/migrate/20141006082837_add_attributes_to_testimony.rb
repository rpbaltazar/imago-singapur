class AddAttributesToTestimony < ActiveRecord::Migration
  def change
    add_column :testimonies, :title, :string
    add_column :testimonies, :headline, :string
  end
end
