class DashboardController < ApplicationController
  layout 'dashboard'
  
  def users
    @users = User.all.order(created_at: :desc)
  end
  
  def contacts
    # Pagination
    page = params[:page] || 1
    per_page = params[:per_page] || 50
    per_page = [per_page.to_i, 200].min # Max 200
    
    # Basic contact query with search
    contacts_scope = Contact.includes(:user)
    
    # Search functionality
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      contacts_scope = contacts_scope.where(
        "name ILIKE ? OR email ILIKE ? OR phone ILIKE ? OR reference_number ILIKE ?",
        search_term, search_term, search_term, search_term
      )
    end
    
    @contacts = contacts_scope.order(created_at: :desc)
                             .limit(per_page)
                             .offset((page.to_i - 1) * per_page.to_i)
    
    # Stats
    @total_contacts = Contact.count
    @contacts_this_month = Contact.where(created_at: Date.current.beginning_of_month..Date.current.end_of_month).count
    @whatsapp_contacts = Contact.where(phone: 'pending-whatsapp').count
    @form_contacts = Contact.where.not(phone: 'pending-whatsapp').count
    
    # Pagination info
    @total_count = params[:search].present? ? contacts_scope.count : @total_contacts
    @current_page = page.to_i
    @per_page = per_page.to_i
    @total_pages = (@total_count.to_f / @per_page).ceil
  end

  def api_activity
    # Week selection (0 = current week, 1 = last week, etc.)
    @week_number = params[:week] || 0
    week_start = @week_number.to_i.weeks.ago.beginning_of_week
    week_end = @week_number.to_i.weeks.ago.end_of_week
    
    # Pagination
    page = params[:page] || 1
    per_page = params[:per_page] || 50
    
    # Get API call counts for all users in selected week
    api_counts_query = Llamada.where(created_at: week_start..week_end)
                              .where.not(user_id: nil)
                              .group(:user_id)
                              .count
    
    # Sort by count and paginate
    sorted_user_ids = api_counts_query.sort_by { |user_id, count| -count }
                                     .slice((page.to_i - 1) * per_page.to_i, per_page.to_i)
                                     .map(&:first)
    
    @users = User.where(id: sorted_user_ids)
    
    # Store API counts and week info for display
    @api_counts = api_counts_query
    @week_start = week_start
    @week_end = week_end
    @total_count = api_counts_query.count
    
    # Pagination info
    @current_page = page.to_i
    @per_page = per_page.to_i
    @total_pages = (@total_count.to_f / @per_page).ceil
  end

  def llamadas
    # EMERGENCY MODE - Ultra minimal loading

    # Only get basic pagination data - NO complex queries
    page = params[:page] || 1
    per_page = [params[:per_page].to_i, 50].max # Min 50, max reasonable
    per_page = [per_page, 200].min # Max 200 to prevent overload

    # Simple query - only current month, only essential data
    first_of_month = Date.current.beginning_of_month

    # Minimal query with essential fields only
    @llamadas_display = Llamada
      .select(:id, :created_at, :ip_address, :user_agent, :request_method, :endpoint)
      .where('created_at >= ?', first_of_month)
      .order(id: :desc)  # Use ID instead of created_at - faster
      .limit(per_page)
      .offset((page.to_i - 1) * per_page.to_i)

    # CACHED stats - only calculate once per day
    cache_key = "llamadas_simple_stats_#{Date.current.strftime('%Y%m%d')}"
    @stats = Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      {
        total_count: Llamada.where('created_at >= ?', first_of_month).count,
        bot_count: 'N/A', # Too expensive to calculate
        suspicious_ips_count: 'N/A',
        unique_ips_count: 'N/A',
        legitimate_count: 'N/A'
      }
    end

    # Extract cached stats
    @total_count = @stats[:total_count]
    @bot_count = @stats[:bot_count]
    @suspicious_ips_count = @stats[:suspicious_ips_count]
    @unique_ips_count = @stats[:unique_ips_count]
    @legitimate_count = @stats[:legitimate_count]

    # Simple pagination - assume no filters for speed
    @filtered_count = @total_count
    @current_page = page.to_i
    @per_page = per_page.to_i
    @total_pages = (@total_count.to_f / @per_page).ceil
  end

  def seo_cache
    @cache_summary = SeoCacheService.cache_summary
    @cache_status = SeoCacheService.cache_status
  end

  def refresh_seo_cache
    brand_slug = params[:brand_slug]

    if brand_slug == 'all'
      # Refresh all brands in background job
      RefreshSeoCacheJob.perform_later
      flash[:notice] = "Actualizando caché de todas las marcas en segundo plano. Esto puede tardar varios minutos."
    elsif brand_slug.present?
      # Refresh specific brand
      results = SeoCacheService.refresh_cache_for_brand(brand_slug)
      successful = results.count { |r| r[:success] }
      flash[:notice] = "✅ Actualizado #{successful} modelos de #{brand_slug}"
    else
      flash[:alert] = "Debe especificar una marca"
    end

    redirect_to dashboard_seo_cache_path
  end

  def clear_seo_cache
    SeoCacheService.clear_cache
    flash[:notice] = "🗑️ Caché SEO eliminado completamente"
    redirect_to dashboard_seo_cache_path
  end
end