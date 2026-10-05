class Membership < ApplicationRecord
  belongs_to :member
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :amount, presence: true
end
