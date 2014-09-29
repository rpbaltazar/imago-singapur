class Testimony < ActiveRecord::Base
  belongs_to :person

  has_attached_file :memory_img, :styles => { :grid => "250x250#", :thumb => "150x150#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :memory_img, :content_type => /\Aimage\/.*\Z/


  def as_json(options={})
    {
      id: id,
      lat: lat,
      lon: lon,
      story_date: story_date,
      memory: memory,
      grid_img: "#{memory_img.url(:grid)}"
    }
  end
end
