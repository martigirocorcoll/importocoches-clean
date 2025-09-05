class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact.subject
  #
  def contact
    @contact = params[:contact]
    
    mail(
      subject: '¡Nou contacte de importocotxe.ad!',
      to: 'info@importocotxe.ad'
    )
  end
  
end
