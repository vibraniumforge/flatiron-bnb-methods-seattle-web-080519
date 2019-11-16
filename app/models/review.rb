class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates_presence_of :rating, :description, :reservation_id

  validate :valid_review

  private

  def valid_review
    if self.reservation.nil? || self.reservation.status != "accepted" || self.reservation.checkout > Date.today
      errors.add(:guest_id, "Reservation is not valid")
      false
    end
  end

end
