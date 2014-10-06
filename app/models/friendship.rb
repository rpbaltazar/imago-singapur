class Friendship < ActiveRecord::Base

  belongs_to :person
  belongs_to :friend_person, class_name: 'Person'

end
