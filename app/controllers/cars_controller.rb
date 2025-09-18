class CarsController < ApplicationController
  invisible_captcha only: [:create], honeypot: :subtitle
  skip_before_action :authenticate_user!
  before_action :models_collection, only: [:pages, :index]
  before_action :set_fuels, only: [:pages, :index]

  def index
    @models = JSON.parse(File.read('lib/marca_model.json'))
    # Call services/car_search to building endpoint
    @endpoint = CarSearch.new(cars_params, params[:order]).call
    # Call services/api_caller.rb to get result XML from query
    doc = ApiCaller.new(@endpoint).call
    @ads = doc.xpath('//ad:ad')
    @number_results = doc.xpath('//search:total').first.content
    # Pagination logic
    @num_pages = doc.xpath('//search:max-pages').first.content.to_i
    @num_pages < 6 ? @num_range = [*2..@num_pages - 1] : @num_range = [*2..4]
    # raise "error"
    #&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    @make = cars_params["make"]
    @model = cars_params["model"]
    @price_min = cars_params["price_min"]
    @price_max = cars_params["price_max"]
    @mileage_max = cars_params["mileage_max"]
    @first_registration_date = cars_params["first_registration_date"]
    @model_description = cars_params["model_description"]
    @order = '&sort.field=price&sort.order=ASCENDING'
    @fuel  = cars_params["fuel"]
    @potencia_minima = cars_params["potencia"]
    @transmision = cars_params["transmision"]
    @fourwheeldrive = cars_params["fourwheeldrive"]
    # &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    @contact = Contact.new
    Llamada.create!(
      endpoint: @endpoint,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      referer: request.referer,
      session_id: session.id,
      request_method: request.method,
      user: current_user
    )
    unless session[:api_counter].nil?
      session[:api_counter] += 1
    end
  end

  def show
    @id = params[:id]
    @final_price = params[:final_price]
    @endpoint = "https://services.mobile.de/search-api/ad/#{params[:id]}"
    @doc = ApiCaller.new(@endpoint).call
    @car = CarShow.new(@doc)
    @contact = Contact.new
    Llamada.create!(
      endpoint: @endpoint,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      referer: request.referer,
      session_id: session.id,
      request_method: request.method,
      user: current_user
    )
    unless session[:api_counter].nil?
      session[:api_counter] += 1
    end
  end

  def showficha
    @id = params[:filters][:id]
    @final_price = params[:filters][:price]
    @endpoint = "https://services.mobile.de/search-api/ad/#{@id}"
    @doc = ApiCaller.new(@endpoint).call
    @car = CarShow.new(@doc)
    @description = params[:filters][:description]
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "ficha",
        template: "cars/showficha.html.erb",
        encoding: 'utf8',
        header: { font_name: "Arial"}
      end
    end
    if @car.images.count % 6 == 0
      @paginas_fotos = @car.images.count / 6
    else
      @paginas_fotos = (@car.images.count / 6) + 1
    end
  end

  def pages
    @contact = Contact.new
    @models = JSON.parse(File.read('lib/marca_model.json'))
    # Storing first endpoint, got from index after filtering
    @first_endpoint = params[:endpoint]
    @actual_page = params[:page].to_i
    # Creating a new endpoint appending page, using first input. Will work to go from any page num.
    @new_endpoint = "#{@first_endpoint}&page.number=#{@actual_page}"
    doc = ApiCaller.new(@new_endpoint).call
    @ads = doc.xpath('//ad:ad')
    @num_pages = doc.xpath('//search:max-pages').first.content.to_i
    @number_results = params[:number_results]
    #&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    @make = cars_params["make"]
    @model = cars_params["model"]
    @price_min = cars_params["price_min"]
    @price_max = cars_params["price_max"]
    @mileage_max = cars_params["mileage_max"]
    @first_registration_date = cars_params["first_registration_date"]
    @model_description = cars_params["model_description"]
    @order = '&sort.field=price&sort.order=ASCENDING'
    @fuel  = cars_params["fuel"]
    @potencia_minima = cars_params["potencia"]
    @transmision = cars_params["transmision"]
    @fourwheeldrive = cars_params["fourwheeldrive"]
    #&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    # Pagination logic
    @num_range_beginning = [*2..3]
    if @actual_page.between?(2, @num_pages - 1)
      @num_next = @actual_page + 1
      @num_prev = @actual_page - 1
    else
      @num_range = [*@actual_page - 3..@actual_page - 1]
    end
    Llamada.create!(
      endpoint: @new_endpoint,
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      referer: request.referer,
      session_id: session.id,
      request_method: request.method
    )
    unless session[:api_counter].nil?
      session[:api_counter] += 1
    end
  end

  private

  def cars_params
    params.require(:filters).permit(
      :make,
      :model,
      :model_description,
      :price_min,
      :price_max,
      :mileage_max,
      :first_registration_date,
      :fuel,
      :order,
      :potencia,
      :transmision,
      :subtitle,
      :fourwheeldrive,
    )
  end

  def models_collection
    @makes =
      [
        "Abarth",
        "Alfa Romeo",
        "Audi",
        "BMW",
        "Bentley",
        "BYD",
        "Citroen",
        "Cupra",
        "Dacia",
        "DS",
        "Fiat",
        "Ford",
        "Genesis",
        "Hyundai",
        "Jaguar",
        "Jeep",
        "Kia",
        "Lamborghini",
        "Land Rover",
        "Lexus",
        "Lotus",
        "Lucid",
        "Maserati",
        "Maxus",
        "Mazda",
        "Mercedes-Benz",
        "MG",
        "Mini",
        "Mitsubishi",
        "Nio",
        "Nissan",
        "Opel",
        "Peugeot",
        "Polestar",
        "Porsche",
        "Renault",
        "Rolls Royce",
        "Seat",
        "Skoda",
        "Smart",
        "Ssangyong",
        "Subaru",
        "Suzuki",
        "Tesla",
        "Toyota",
        "VW",
        "Volvo",
        "XPENG"
      ]
  end

  def set_fuels
    @fuel_list =
      [
        "Eléctrico",
        "Híbrido (gasolina/eléctrico)",
        "Híbrido (diésel/eléctrico)"
      ]
  end

end
