class ClassEnrollment < ApplicationRecord
  belongs_to :member
  belongs_to :gym_class
end
