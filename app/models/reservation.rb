class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates_presence_of :checkout, :checkin
  validate :guest_is_not_host, :valid_checkin_and_checkout, :check_availablity

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.duration * self.listing.price
  end 

  def guest_is_not_host
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "Can't book own apartment!")
    end
  end

  def valid_checkin_and_checkout
    if self.checkin && self.checkout
      if self.checkin >= self.checkout
        errors.add(:guest_id, "Error")
      end
    end
  end

  def check_availablity
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

end
