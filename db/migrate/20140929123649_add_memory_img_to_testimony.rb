class AddMemoryImgToTestimony < ActiveRecord::Migration
  def self.up
    add_attachment :testimonies, :memory_img
  end

  def self.down
    remove_attachment :testimonies, :memory_img
  end
end
