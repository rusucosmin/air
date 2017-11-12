class JoggingLogSerializer < ActiveModel::Serializer
  attributes :id, :date, :duration, :distance
  has_one :user
end
