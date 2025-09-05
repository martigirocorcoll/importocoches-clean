class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :registerable
  # after_create :subscribe_to_newsletter
  # after_create :send_welcome_email

  # Validations
  validates :telephone, presence: true, if: :telephone_required?
  validates :telephone, format: { with: /\A[\+]?[0-9\s\-\(\)]+\z/, message: "Please enter a valid telephone number" }, allow_blank: true

  # Associations
  has_many :llamadas, dependent: :nullify

  def subscribe_to_newsletter
    SubscribeToNewsletterService.new(self).call
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  # API usage stats
  def api_calls_this_month
    llamadas.where(created_at: Date.current.beginning_of_month..Date.current.end_of_month).count
  end

  def api_calls_today
    llamadas.where(created_at: Date.current.all_day).count
  end

  def total_api_calls
    llamadas.count
  end

  def last_api_call
    llamadas.order(created_at: :desc).first&.created_at
  end

  def is_active_user?
    last_api_call && last_api_call > 30.days.ago
  end

  def telephone_missing?
    telephone.blank?
  end

  # API limit methods
  API_LIMIT = 50

  def api_limit_reached?
    return false if bypass_api_limit?
    total_api_calls >= API_LIMIT
  end

  def api_calls_remaining
    return 999 if bypass_api_limit?
    [API_LIMIT - total_api_calls, 0].max
  end

  def increment_api_calls!
    # Use the existing llamadas relationship to count
    # This ensures consistency with the existing logging system
    reload # Refresh the llamadas count
  end

  def telephone_required?
    # Only require telephone for new registrations or when explicitly updating telephone
    new_record? || will_save_change_to_telephone?
  end

  private

  def bypass_api_limit?
    # Allow specific users to bypass API limits for testing/admin purposes
    email == 'marti@gmail.com'
  end

end
