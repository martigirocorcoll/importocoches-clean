class Admin::UsersController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in
  before_action :ensure_admin # Add admin check if needed
  
  def index
    @view = params[:view] || 'registration' # Default view
    @search = params[:search]
    
    # Pagination
    page = params[:page] || 1
    per_page = params[:per_page] || 50
    
    case @view
    when 'registration'
      # View 1: All users by registration order
      users_scope = User.select(:id, :email, :created_at)
      
      # Apply search if present
      if @search.present?
        users_scope = users_scope.where(
          "email ILIKE ? OR id::text ILIKE ?", 
          "%#{@search}%", "%#{@search}%"
        )
      end
      
      @users = users_scope.order(created_at: :desc)
                          .limit(per_page)
                          .offset((page.to_i - 1) * per_page.to_i)
      
      @total_count = @search.present? ? users_scope.count : User.count
      
    when 'api_activity'
      # View 2: Users with API calls by week
      @week_number = params[:week] || 0 # 0 = current week, 1 = last week, etc.
      week_start = @week_number.to_i.weeks.ago.beginning_of_week
      week_end = @week_number.to_i.weeks.ago.end_of_week
      
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
                   .select(:id, :email, :created_at)
      
      # Store API counts and week info for display
      @api_counts = api_counts_query
      @week_start = week_start
      @week_end = week_end
      @total_count = api_counts_query.count
    end
    
    # Pagination info
    @current_page = page.to_i
    @per_page = per_page.to_i
    @total_pages = (@total_count.to_f / @per_page).ceil
    
    # Simple stats - only total users
    @total_users = User.count
  end

  def show
    @user = User.find(params[:id])
    
    # API usage stats for this user
    @api_stats = {
      total_calls: @user.total_api_calls,
      calls_this_month: @user.api_calls_this_month,
      calls_today: @user.api_calls_today,
      last_call: @user.last_api_call,
      is_active: @user.is_active_user?
    }
    
    # Recent API calls for this user (paginated)
    page = params[:page] || 1
    per_page = 20
    
    @recent_calls = @user.llamadas
                         .order(created_at: :desc)
                         .limit(per_page)
                         .offset((page.to_i - 1) * per_page.to_i)
    
    # Monthly breakdown (last 6 months)
    @monthly_usage = 6.times.map do |i|
      month_start = i.months.ago.beginning_of_month
      month_end = i.months.ago.end_of_month
      calls = @user.llamadas.where(created_at: month_start..month_end).count
      {
        month: month_start.strftime('%m/%Y'),
        calls: calls
      }
    end.reverse
  end

  private

  def ensure_admin
    # Only allow access to marti@gmail.com
    unless current_user&.email == 'marti@gmail.com'
      redirect_to root_path, alert: 'Acceso denegado. No tienes permisos para acceder a esta sección.'
      return false
    end
    true
  end

  def calculate_user_stats
    total_users = User.count
    
    # Users with API calls
    users_with_calls = User.joins(:llamadas).distinct.count
    
    # Active users (last 30 days)
    recent_user_ids = Llamada.where('created_at > ?', 30.days.ago)
                             .where.not(user_id: nil)
                             .distinct
                             .pluck(:user_id)
    active_users = recent_user_ids.count
    
    # Heavy users (>50 calls this month)
    first_of_month = Date.current.beginning_of_month
    heavy_user_ids = Llamada.where(created_at: first_of_month..Date.current.end_of_month)
                            .where.not(user_id: nil)
                            .group(:user_id)
                            .having('COUNT(*) > 50')
                            .pluck(:user_id)
    heavy_users = heavy_user_ids.count
    
    {
      total_users: total_users,
      users_with_calls: users_with_calls,
      active_users: active_users,
      heavy_users: heavy_users,
      inactive_users: total_users - active_users
    }
  end
end