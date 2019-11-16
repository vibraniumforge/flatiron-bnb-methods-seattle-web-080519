class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  # validates :address, presence: true
  # validates :listing_type, presence: true
  # validates :title, presence: true
  # validates :description, presence: true
  # validates :price, presence: true
  # validates :neighborhood_id, presence: true

  validates_presence_of :address, :listing_type, :title, :description, :price, :neighborhood_id

  after_save :set_host_status_to_true
  before_destroy :set_host_status_to_false

  def average_review_rating
    # reviews = self.reviews.pluck("rating") 
    # reviews.sum/reviews.count.to_f

     reviews.average(:rating)
  end


  def self.available(start_date, end_date)
    if start_date && end_date
     joins(:reservations).where.not(reservations: {checkin: start_date..end_date}) & joins(:reservations).where.not(reservations: {checkout: start_date..end_date}).distinct
    else 
      []
    end
  end

  def set_host_status_to_false
    if self.host.listings.count <=1
      self.host.update(:host => false)
    end
  end

  def set_host_status_to_true
    unless host.host
      self.host.update(:host => true)
    end
  end
 
end
