class CreateTestemonies < ActiveRecord::Migration
  def change
    create_table :testemonies do |t|
      t.float :lat
      t.float :lon
      t.datetime :story_date
      t.string :memory
      t.string :audio_url
      t.string :video_url

      t.timestamps
    end
  end
end
