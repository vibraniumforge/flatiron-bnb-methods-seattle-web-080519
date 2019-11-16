class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

<<<<<<< HEAD
  validates_presence_of :rating, :description, :reservation_id

  validate :valid_review

  private

  def valid_review
    if self.reservation.nil? || self.reservation.status != "accepted" || self.reservation.checkout > Date.today
      errors.add(:guest_id, "Reservation is not valid")
      false
    end
  end

=======
  validates :description, presence: true
  validates :rating, presence: true, numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 5,
              only_integer: true
            }
  validates :reservation, presence: true

  validate :checked_out
  validate :reservation_accepted

  private

  def checked_out
    if reservation && reservation.check_out > Date.today
      errors.add(:reservation, "Reservation must have ended to leave a review.")
    end
  end

  def reservation_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation must be accepted to leave a review.")
    end
  end
>>>>>>> 6efa43379e76796772db971f478cbfc3aca76b1a
end
