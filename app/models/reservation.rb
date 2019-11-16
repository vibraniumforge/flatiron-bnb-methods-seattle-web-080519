class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review

<<<<<<< HEAD

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
=======
  validates :check_in, :check_out, presence: true
  validate :available, :check_out_after_check_in, :guest_and_host_not_the_same

  def duration
    (check_out - check_in).to_i
  end

  def total_price
    listing.price * duration
  end

  private
  

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.check_in..r.check_out
      if booked_dates === check_in || booked_dates === check_out
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
>>>>>>> 6efa43379e76796772db971f478cbfc3aca76b1a
      end
    end
  end

<<<<<<< HEAD
  def check_availablity
    # result = Reservation.where(listing_id == self.id, self.checkin(checkin..checkout), self.checkin(checkout..checkin))
    # if result.size > 0
    #   errors.add(:guest_id, "Error")
    # end
  end

=======
  def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own apartment.")
    end
  end

  def check_out_after_check_in
    if check_out && check_in && check_out <= check_in
      errors.add(:guest_id, "Your check-out date needs to be after your check-in.")
    end
  end
>>>>>>> 6efa43379e76796772db971f478cbfc3aca76b1a
end
