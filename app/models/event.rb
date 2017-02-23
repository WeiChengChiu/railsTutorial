class Event < ApplicationRecord

  belongs_to :user
  has_many :attendees

  has_many :event_groupships
  has_many :groups, :through => :event_groupships

  validates_presence_of :name

end
