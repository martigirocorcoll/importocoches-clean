class CarSearch

  def initialize(cars_params, order = "")
    # CarSearch will take all the params from home's filters
    @price_min = cars_params["price_min"]
    @price_max = cars_params["price_max"]
    @mileage_max = cars_params["mileage_max"]
    @first_registration_date = cars_params["first_registration_date"]
    @make = cars_params["make"]
    @model = cars_params["model"]
    @model_description = cars_params["model_description"]
    @order = '&sort.field=price&sort.order=ASCENDING'
    @fuel  = cars_params["fuel"]
    @potencia_minima = cars_params["potencia"]
    @transmision = cars_params["transmision"]
    @fourwheeldrive = cars_params["fourwheeldrive"]
  end

  def call
    # To build enpoint we have to append all different queries (filter name & input from user)
    unless @price_min.blank?
      price_min = "&price.min=#{@price_min}"
    else
      price_min = "&price.min=8000.00"
    end
    price_max = "&price.max=#{@price_max}" unless @price_max.blank?
    mileage_max = "&mileage.max=#{@mileage_max}" unless @mileage_max.blank?
    potencia = "&power.min=#{@potencia_minima}" unless @potencia_minima.blank?
    transmision = "&gearbox=#{@transmision}" unless @transmision.blank?
    if @first_registration_date.blank?
      first_registration_date = "&firstRegistrationDate.min=2019-01"
    else
      first_registration_date = "&firstRegistrationDate.min=#{@first_registration_date}-01"
    end
    fuel = build_fuel_filter
    make = "&classification=refdata/classes/Car/makes/#{@make.upcase}" unless @make.blank?
    model = "/models/#{@model.upcase}" unless @model.blank?
    model_description = "&modelDescription=#{@model_description}" unless @model_description.blank?
    fourwheeldrive = "&feature=FOUR_WHEEL_DRIVE" unless @fourwheeldrive=="0"
    # "https://services.mobile.de/search-api/search?vatable=1&#{make}#{model}#{model_description}#{potencia}#{transmision}&damageUnrepaired=0#{price_min}#{price_max}#{mileage_max}#{first_registration_date}#{fuel}#{fourwheeldrive}#{@order}"
    "https://services.mobile.de/search-api/search?#{make}#{model}#{model_description}#{potencia}#{transmision}&damageUnrepaired=0#{price_min}#{price_max}#{mileage_max}#{first_registration_date}#{fuel}#{fourwheeldrive}#{@order}"


  end

  def build_fuel_filter
    if @fuel.blank?
      # Sin selección: filtrar automáticamente por los 3 tipos eco-friendly
      "&fuel=ELECTRICITY&fuel=HYBRID&fuel=HYBRID_DIESEL"
    else
      # Con selección: usar solo el seleccionado
      "&fuel=#{find_fuel}"
    end
  end

  def find_fuel
    case @fuel
    when "Gasolina"
      "PETROL"
    when "Diésel"
      "DIESEL"
    when "Gas de automoción"
      "LPG"
    when "Gas natural"
      "CNG"
    when "Eléctrico"
      "ELECTRICITY"
    when "Híbrido (gasolina/eléctrico)"
      "HYBRID"
    when "Hidrógeno"
      "HYDROGENIUM"
    when "Etanol (FFV,E85, etc.)"
      "ETHANOL"
    when "Híbrido (diésel/eléctrico)"
      "HYBRID_DIESEL"
    when "Otro"
      "OTHER"
    end
  end
end
