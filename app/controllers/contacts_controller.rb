class ContactsController < ApplicationController
  invisible_captcha only: [:create], honeypot: :subtitle
  skip_before_action :authenticate_user!

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.user = current_user if user_signed_in?
    @contact.utm_params = session[:utm_params] || ''
    
    if @contact.save!
      flash[:success] = "¡Gracias por tu mensaje, #{@contact.name}! Te contactaremos lo antes posible. Puedes seguir enviándonos otros vehiculos que te gusten"
      redirect_to root_path
    else
      render :new
      flash[:alert] = "¡Oups! Algo fue mal, inténtalo de nuevo."
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :comment, :mobile_link, :price, :source, :page_url)
  end

end
