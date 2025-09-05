class ContractsController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard', only: [:new]
  
  def new
    # Formulario para generar contrato
  end
  
  def generate_pdf
    # Recoger datos del formulario (ahora vienen dentro de contract_data)
    contract_params = params[:contract_data] || params
    
    # Determinar el idioma del contrato
    lang = params[:lang] || contract_params[:lang] || 'es'
    
    @contract_data = {
      # Datos del vehículo
      car_id: contract_params[:car_id],
      marca_model: contract_params[:marca_model],
      km: contract_params[:km],
      primera_matriculacion: contract_params[:primera_matriculacion],
      chassis: contract_params[:chassis],
      venta_total: contract_params[:venta_total],
      deposito: contract_params[:deposito],
      descripcion_traducida: contract_params[:descripcion_traducida],
      comentarios: contract_params[:comentarios],
      
      # Datos del cliente
      empresa: contract_params[:empresa].presence,
      nrt: contract_params[:nrt].presence,
      domicilio: contract_params[:domicilio],
      nombre: contract_params[:nombre],
      nia: contract_params[:nia]
    }
    
    # Calcular pago restante
    @contract_data[:pago_restante] = @contract_data[:venta_total].to_f - @contract_data[:deposito].to_f
    
    # Fecha del contrato
    @contract_data[:fecha] = Date.today.strftime("%d/%m/%Y")
    
    # Obtener datos del coche de la API si necesario
    if @contract_data[:car_id].present?
      @id = @contract_data[:car_id]
      @final_price = @contract_data[:venta_total]
      @endpoint = "https://services.mobile.de/search-api/ad/#{@id}"
      @doc = ApiCaller.new(@endpoint).call
      @car = CarShow.new(@doc)
      @description = @contract_data[:descripcion_traducida]
      
      # Calcular páginas de fotos como en showficha
      if @car.images.count % 6 == 0
        @paginas_fotos = @car.images.count / 6
      else
        @paginas_fotos = (@car.images.count / 6) + 1
      end
    end
    
    # Seleccionar la plantilla según el idioma
    template = lang == 'en' ? "contracts/contract_pdf_en.html.erb" : "contracts/contract_pdf.html.erb"
    
    # Generar PDF
    respond_to do |format|
      format.pdf do
        render pdf: "contrato_reserva_#{@contract_data[:marca_model].parameterize}",
               template: template,
               encoding: 'utf8',
               header: { font_name: "Arial" }
      end
    end
  end
  
  private
end