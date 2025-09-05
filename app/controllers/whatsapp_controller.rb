class WhatsappController < ApplicationController
  skip_before_action :authenticate_user!

  def redirect
    contact = create_whatsapp_contact
    whatsapp_url = generate_whatsapp_url(contact)

    redirect_to whatsapp_url, allow_other_host: true
  end

  private

  def create_whatsapp_contact
    Contact.create!(
      name: "WhatsApp Lead #{Time.current.strftime('%d/%m %H:%M')}",
      phone: "pending-whatsapp",
      email: "info@importocotxe.ad",
      source: determine_source,
      # Use page_url parameter from the link, or fallback to referer
      page_url: params[:page_url] || request.referer || 'Direct access',
      # Always capture user if logged in
      user: user_signed_in? ? current_user : nil,
      # Capture UTM params from session
      utm_params: session[:utm_params] || ''
    )
  end

  def determine_source
    source = params[:source]&.downcase

    # Validar que el source esté en VALID_SOURCES del modelo Contact
    if Contact::VALID_SOURCES.include?(source)
      source
    else
      'unknown'
    end
  end



  def generate_whatsapp_url(contact)
    phone_number = "+376666488" # Tu número de WhatsApp
    message = build_whatsapp_message(contact)
    encoded_message = CGI.escape(message)

    "https://wa.me/#{phone_number}?text=#{encoded_message}"
  end

  def build_whatsapp_message(contact)
    source = params[:source]
    base_message = get_message_for_source(source)

    "#{base_message} Ref: #{contact.reference_number}"
  end

  def get_message_for_source(source)
    case source
    when 'bmw'
      "Hola! Estoy interesado en importar un BMW."
    when 'audi'
      "Hola! Estoy interesado en importar un Audi."
    when 'mercedes'
      "Hola! Estoy interesado en importar un Mercedes."
    when 'porsche'
      "Hola! Estoy interesado en importar un Porsche."
    when 'tesla'
      "Hola! Estoy interesado en importar un Tesla."
    when 'mini'
      "Hola! Estoy interesado en importar un Mini."
    when 'volkswagen'
      "Hola! Estoy interesado en importar un Volkswagen."
    when 'cupra'
      "Hola! Estoy interesado en importar un Cupra."
    when 'lamborghini'
      "Hola! Estoy interesado en importar un Lamborghini."
    when 'car_detail'
      "Hola! Estoy interesado en este coche específico."
    when 'car_search'
      "Hola! No encuentro exactamente lo que busco. ¿Podrían ayudarme?"
    when 'api_limit'
      "Hola! Me interesa conocer más sobre sus servicios de importación."
    when 'main'
      "Hola! Me gustaría obtener información sobre importación de coches."
    else
      "Hola! Me interesa importar un coche."
    end
  end
end
