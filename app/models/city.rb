class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  include Reservable

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end

  def self.highest_ratio_res_to_listings
    all.max do |a,b|
      a.ratio_reservations_to_listings <=> b.ratio_reservations_to_listings
    end
  end

  def self.most_res
    all.max do |a,b|
      a.reservations.count <=> b.reservations.count
    end
  end

end

