class User < ApplicationRecord
  has_many :profiles

  def self.ransackable_associations(auth_object = nil)
    ["profiles"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "updated_at"]
  end
end
