class JoggingLog < ApplicationRecord
  belongs_to :user
  validates_presence_of :date
  validates_presence_of :duration
  validates_presence_of :distance
  validates_numericality_of :duration
  validates_numericality_of :distance
  validates_date :date, :before => Date.today, :before_message => "appears ts be in the future"
end
