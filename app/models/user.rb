class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,  presence: true,
                    length: {maximum: Settings.user.length_of_name}
  validates :email, presence: true,
                    length: {maximum: Settings.user.length_of_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
                       length: {minimum: Settings.user.length_of_password}
  before_save :downcase_email
  has_secure_password

  def downcase_email
    self.email.downcase!
  end
end
