class BuyItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_one :buylist
end
