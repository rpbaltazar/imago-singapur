class Person < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_many :testimonies

  has_many :friendships
  has_many :friends, :through => :friendships, :source => :friend_person

end
