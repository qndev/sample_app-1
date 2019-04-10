class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :remember_token
  has_many :microposts, dependent: :destroy
  validates :name,  presence: true,
                    length: {maximum: Settings.user.length_of_name}
  validates :email, presence: true,
                    length: {maximum: Settings.user.length_of_email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
                       length: {minimum: Settings.user.length_of_password},
                       allow_nil: true
  before_save :downcase_email
  has_secure_password
  paginates_per Settings.user.per_page

  default_scope ->{order(created_at: :desc)}

  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    @remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update :remember_digest, nil
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    @activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
