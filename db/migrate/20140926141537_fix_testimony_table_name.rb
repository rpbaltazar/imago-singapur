class FixTestimonyTableName < ActiveRecord::Migration
  def change
    rename_table :testemonies, :testimonies
  end
end
