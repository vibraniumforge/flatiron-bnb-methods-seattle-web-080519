class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  before_save :make_host
  before_destroy :host_status

  def make_host
    self.host.update(:host => true)
  end

  def host_status
    if self.host.listings.count <=1
      self.host.update(:host => false)
    end
  end

  def average_review_rating
    reviews = self.reviews.pluck("rating") 
    reviews.sum/reviews.count.to_f
  end

end
