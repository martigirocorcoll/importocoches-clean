class Contact < ApplicationRecord
  VALID_EMAIL_REGEX = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i

  belongs_to :user, optional: true
  
  validates :name, presence: true
  validates :phone, presence: true
  validates :email, presence: true,
  format: { with: VALID_EMAIL_REGEX, multiline:true }
  
  # Source tracking for different form origins
  validates :source, presence: true
  
  VALID_SOURCES = %w[
    bmw audi mercedes porsche tesla mini volkswagen cupra lamborghini
    landing hero blog contact import cars web rate_limit unknown
  ].freeze
  
  validates :source, inclusion: { in: VALID_SOURCES }

  before_create :generate_reference_number
  after_create :send_email, :send_email_contact
  # after_create :send_email
  

  private

  def send_email
    # Skip email for WhatsApp clicks
    return if phone == 'pending-whatsapp'
    
    ContactMailer.with(contact: self).contact.deliver_now
  rescue => e
    Rails.logger.error "Failed to send contact email: #{e.message}"
    # Don't crash the form submission if email fails
  end

  def send_email_contact
    # Skip email for WhatsApp clicks
    return if phone == 'pending-whatsapp'
    
    ContactoMailer.received(self).deliver_now
  rescue => e
    Rails.logger.error "Failed to send contact confirmation email: #{e.message}"
    # Don't crash the form submission if email fails
  end

  def generate_reference_number
    return if reference_number.present? # Don't overwrite existing reference
    
    loop do
      # Different prefixes based on source and contact type
      prefix = if phone == 'pending-whatsapp'
                 'WA' # WhatsApp
               else
                 case source
                 when 'landing', 'hero', 'contact', 'import', 'cars', 'web'
                   'WB' # Web form
                 when 'bmw', 'audi', 'mercedes', 'porsche', 'tesla', 'mini', 'volkswagen', 'cupra', 'lamborghini'
                   'BR' # Brand form
                 when 'blog'
                   'BL' # Blog form
                 when 'rate_limit'
                   'RL' # Rate limit form
                 else
                   'GN' # General
                 end
               end
      
      reference = "#{prefix}#{Time.current.strftime('%y%m%d')}#{SecureRandom.hex(3).upcase}"
      
      unless Contact.exists?(reference_number: reference)
        self.reference_number = reference
        break
      end
    end
  end

end
