class AddImageUrlToTestemony < ActiveRecord::Migration
  def change
    add_column :testemonies, :image_url, :string
  end
end
