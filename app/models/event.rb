class Event < ApplicationRecord
  belongs_to :host, class_name: "Account"
  has_many :account_events, foreign_key: "event_id"
  has_many :guests, through: :account_events, source: :account

  # to do validations
  validates :spot, presence: true
  validates :budget, presence: true
  validates :location, presence: true
  validates :cuisine, presence: true
  validates :time, presence: true

  def is_active?
    return !self.time.past?
  end

  def self.event_search(arr, term)
    temp = arr
    temp = temp.select do |event| 
      (event.spot.downcase.include?(term.downcase) || event.location.downcase.include?(term.downcase) || event.cuisine.downcase.include?(term.downcase))
    end

    if temp.empty?
      return arr
    else
      return temp
    end
  end

  def self.events_coming_up
    return self.order('time DESC').limit(5).select { |event| event.is_active? }
  end
 
end
