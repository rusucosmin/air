class User < ApplicationRecord
  has_secure_password
  has_many :jogging_logs

  enum role: [:user, :manager, :admin]

  validates_length_of :password, maximum: 72, minimum: 8, allow_nil: true,
      allow_blank: false

  before_validation {
    self.email = self.email.to_s.downcase
  }

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_email_format_of :email

  def can_modify_user?(user)
    admin? || User.roles[role] > User.roles[user.role] || id.to_s == user.id.to_s
  end
end
