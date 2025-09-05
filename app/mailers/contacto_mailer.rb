class ContactoMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contacto_mailer.received.subject
  #
  def received(contact)
    @contact = contact

    mail to: @contact.email, subject: 'Importocotxe.ad: Petició rebuda'
  end
end
