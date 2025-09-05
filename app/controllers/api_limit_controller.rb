class ApiLimitController < ApplicationController
  skip_before_action :check_telephone_required
  skip_before_action :check_api_limit
  
  def show
    # Only show this page if user has actually reached the limit
    redirect_to root_path unless user_signed_in? && current_user.api_limit_reached?
  end

  def contact_submitted
    # Track that user submitted contact form from API limit page
    if user_signed_in?
      # Log this conversion event
      Rails.logger.info("API Limit Conversion: User #{current_user.id} submitted contact form")
    end
    
    flash[:success] = t('pages.api_limit.contact_success')
    redirect_to root_path
  end
end