class Event < ApplicationRecord

  has_many :attendees

  validates_presence_of :name

end
