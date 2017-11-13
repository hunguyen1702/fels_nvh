class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  enum role: {normal_user: 0, admin: 1}

  has_many :activities, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  has_secure_password

  mount_uploader :avatar, AvatarUploader

  before_save :downcase_email
  before_create :create_activation_token

  validates :name, presence: true, length: {maximum: Settings.user.max_name}
  validates :email, presence: true, length: {maximum: Settings.user.max_email},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user.min_password}, on: :create
  validates :password, presence: true,
    length: {minimum: Settings.user.min_password},
    on: :update, if: :password_changed?
  validate :avatar_size

  scope :users_info, ->{select :id, :name, :email, :avatar}
  scope :activated_user, ->{where is_activated: true}
  scope :all_except, ->user{where.not id: user}

  paginates_per Settings.user.page_size
  max_paginates_per Settings.user.page_size

  class << self
    def digest string
      if ActiveModel::SecurePassword.min_cost
        cost = BCrypt::Engine::MIN_COST
      else
        cost = BCrypt::Engine.cost
      end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def is_user? user
    self == user
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? token_type, token
    digest = send("#{token_type}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attributes remember_digest: nil
  end

  def activate
    update_attributes is_activated: true,
      activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.user.password_reset_expired.hours.ago
  end

  def learned_words
    user_answers = Result.lesson_answers lessons.ids
    Answer.in_set(user_answers).correct_answers.select :word_id
  end

  def learned? word
    learned_words.any?{|w| w.word_id == word.id}
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def relationship
    active_relationships.build
  end

  def current_relationship user_id
    active_relationships.find_by followed_id: user_id
  end

  def activities_feed
    following_users = Relationship.following_of id
    Activity.feed(id, following_users).desc
  end

  private

  def avatar_size
    return if avatar.size < Settings.user.avatar_size.megabytes

    errors.add :avatar,
      t("user.edit_view.avatar_error", size: Settings.user.avatar_size)
  end

  def downcase_email
    email.downcase!
  end

  def password_changed?
    password.present?
  end

  def create_activation_token
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
