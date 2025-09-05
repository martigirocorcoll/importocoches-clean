class EncargosController < ApplicationController
  before_action :set_encargo, only: %i[ show edit update destroy ]

  # GET /encargos or /encargos.json
  def index
    @encargos = Encargo.all
    @total= 0
  end

  def indextotal
    @encargos = Encargo.all
  end
  # GET /encargos/1 or /encargos/1.json
  def show
  end

  # GET /encargos/new
  def new
    @encargo = Encargo.new
  end

  # GET /encargos/1/edit
  def edit
  end

  # POST /encargos or /encargos.json
  def create
    @encargo = Encargo.new(encargo_params)

    respond_to do |format|
      if @encargo.save
        format.html { redirect_to encargo_url(@encargo), notice: "Encargo was successfully created." }
        format.json { render :show, status: :created, location: @encargo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @encargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /encargos/1 or /encargos/1.json
  def update
    respond_to do |format|
      if @encargo.update(encargo_params)
        format.html { redirect_to encargo_url(@encargo), notice: "Encargo was successfully updated." }
        format.json { render :show, status: :ok, location: @encargo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @encargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /encargos/1 or /encargos/1.json
  def destroy
    @encargo.destroy

    respond_to do |format|
      format.html { redirect_to encargos_url, notice: "Encargo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_encargo
      @encargo = Encargo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def encargo_params
      params.require(:encargo).permit(:nombre, :fpago_coche, :frecogida, :fentrada_and, :fcobro_iva, :contacto, :cantidad_iva, :direccion_recog, :comentario)
    end
end
