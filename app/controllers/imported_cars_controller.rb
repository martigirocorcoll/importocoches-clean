class ImportedCarsController < ApplicationController
  before_action :set_imported_car, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: [:index, :show]


  # GET /imported_cars or /imported_cars.json
  def index
    @imported_cars = ImportedCar.order(created_at: :desc).page(params[:page])
  end

  # GET /imported_cars/1 or /imported_cars/1.json
  def show
    @contact = Contact.new
    # Figure out which column to pull based on current locale
    lang = I18n.locale.to_s
    column = "long_description_#{lang}"

    # Safely read it (fallback to Spanish if somehow locale isn’t one of ours)
    @long_description =
      if @imported_car.respond_to?(column)
        @imported_car.public_send(column)
      else
        @imported_car.long_description_es
      end
    # Ensure we don't include the current car in the index list
    @imported_cars = ImportedCar.where.not(id: @imported_car.id) if @imported_car.present?
  end

  # GET /imported_cars/new
  def new
    @imported_car = ImportedCar.new
  end

  # GET /imported_cars/1/edit
  def edit
  end

  # POST /imported_cars or /imported_cars.json
  def create
    @imported_car = ImportedCar.new(imported_car_params)

    respond_to do |format|
      if @imported_car.save
        format.html { redirect_to imported_car_url(@imported_car), notice: "Imported car was successfully created." }
        format.json { render :show, status: :created, location: @imported_car }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @imported_car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imported_cars/1 or /imported_cars/1.json
  def update
    respond_to do |format|
      if @imported_car.update(imported_car_params)
        format.html { redirect_to imported_car_url(@imported_car), notice: "Imported car was successfully updated." }
        format.json { render :show, status: :ok, location: @imported_car }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @imported_car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /imported_cars/1 or /imported_cars/1.json
  def destroy
    @imported_car.destroy

    respond_to do |format|
      format.html { redirect_to imported_cars_url, notice: "Imported car was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_imported_car
      @imported_car = ImportedCar.find_by!(slug: params[:slug])
    end

    # Only allow a list of trusted parameters through.
    def imported_car_params
      params.require(:imported_car).permit(:brand, :model, :year, :mileage, :horsepower, :fuel_type, :long_description_es, :long_description_en, :long_description_cat, :long_description_fr, :ad_image_urls, :real_image_urls, :video_urls, :precio, :ficha_pdf, :imported_date, :slug)
    end
end
