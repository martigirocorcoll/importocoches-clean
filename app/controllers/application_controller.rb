class ApplicationController < ActionController::Base
  # Set locale first before any other actions
  around_action :switch_locale
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_variant_param
  before_action :capture_attribution_data
  before_action :check_telephone_required, unless: :devise_controller?
  before_action :check_api_limit, unless: :devise_controller?


  # def switch_locale(&action)
  #   locale = params[:locale] || I18n.default_locale
  #   I18n.with_locale(locale, &action)
  # end


  def switch_locale(&action)
    if params[:locale]
      locale = params[:locale] || I18n.default_locale
    else
      locale = extract_locale_from_accept_language_header || I18n.default_locale
    end
    I18n.with_locale(locale, &action)
  end

  # def set_locale
  #   locale = extract_locale_from_accept_language_header || I18n.default_locale
  # end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end
  # include Pundit

  # # Pundit: white-list approach.
  # after_action :verify_authorized, except: :index, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # # Uncomment when you *really understand* Pundit!
  # # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # # def user_not_authorized
  # #   flash[:alert] = "You are not authorized to perform this action."
  # #   redirect_to(root_path)
  # # end

  private

  def capture_attribution_data
    # Only capture on first visit to preserve original attribution
    return if session[:utm_params].present?
    
    # Only capture if we have UTM parameters or click IDs
    return unless has_utm_or_click_parameters?
    
    Rails.logger.info "📊 NEW SESSION: Capturing UTM data for new visitor"
    
    # Simply store the raw query string if it contains UTM params
    session[:utm_params] = request.query_string
    
    Rails.logger.info "📊 UTM PARAMS CAPTURED: #{session[:utm_params]}"
  end
  
  def has_utm_or_click_parameters?
    utm_params = %w[utm_source utm_medium utm_campaign utm_term utm_content]
    click_ids = %w[gclid msclkid fbclid]
    
    (utm_params + click_ids).any? { |param| params[param].present? }
  end

  def check_variant_param
    case params[:variant]
    when "chatbot"
      # Si en la URL viene ?variant=chatbot, activamos el chatbot
      session[:use_chatbot] = true

    when "whatsapp"
      # Si en la URL viene ?variant=whatsapp, volvemos a WhatsApp
      session.delete(:use_chatbot)

    else
      # No hacemos nada si no viene ningún param “variant”
      # (o viene otro valor distinto a "chatbot"/"whatsapp")
    end
  end

  helper_method :use_chatbot?
  def use_chatbot?
    session[:use_chatbot].present?
  end

  def check_telephone_required
    return unless user_signed_in?
    return if current_user.telephone.present?
    return if request.path == complete_telephone_path
    return if request.path == telephone_path
    return if request.path == destroy_user_session_path

    flash[:notice] = t('pages.complete_telephone.required_notice')
    redirect_to complete_telephone_path
  end

  def check_api_limit
    return unless user_signed_in?
    return if current_user.api_calls_remaining > 0
    return if request.path == api_limit_reached_path
    return if request.path == api_limit_contact_path
    return if request.path == destroy_user_session_path
    return if request.path.start_with?('/contacts')

    redirect_to api_limit_reached_path
  end
  # def set_locale
  #   I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
  # end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
  end
  
  def extract_page_title
    # Extract page title based on controller and action
    case "#{controller_name}##{action_name}"
    when "pages#home"
      "Página Principal"
    when "pages#show_brand"
      "Página #{params[:brand_slug]&.humanize}"
    when "pages#show_model"
      "Página #{params[:brand_slug]&.humanize} #{params[:model_slug]&.humanize}"
    when "cars#index"
      "Búsqueda de Coches"
    when "cars#show"
      "Detalle de Coche"
    when "contacts#new"
      "Formulario de Contacto"
    else
      "#{controller_name.humanize} - #{action_name.humanize}"
    end
  end

  # def skip_pundit?
  #   devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname, :telephone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fname, :lname, :telephone])
  end
end
