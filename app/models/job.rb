class Job < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true, length: {minimum: 40}
end
