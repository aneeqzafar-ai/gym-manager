class Member < ApplicationRecord
  has_many :memberships
  validates :name, presence: true
end
