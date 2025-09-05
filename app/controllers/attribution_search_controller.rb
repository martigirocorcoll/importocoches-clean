class AttributionSearchController < ApplicationController
  layout 'dashboard'
  
  def show
    @reference = params[:reference]
    @contact = nil
    @attribution_info = nil
    
    if @reference.present?
      @contact = Contact.find_by(reference_number: @reference.upcase)
      
      if @contact
        @attribution_info = format_attribution_info(@contact)
      else
        flash.now[:alert] = "No se encontró ningún contacto con la referencia: #{@reference}"
      end
    end
  end
  
  private
  
  def format_attribution_info(contact)
    return {} unless contact
    
    {
      utm_params: contact.utm_params.presence || "Tráfico directo - Sin parámetros UTM",
      page_url: contact.page_url || "No especificado",
      created_at: contact.created_at.strftime("%d/%m/%Y %H:%M"),
      source: contact.source&.humanize || "No especificado",
      name: contact.name,
      phone: contact.phone,
      email: contact.email,
      user_email: contact.user&.email,
      user_id: contact.user&.id
    }
  end
end