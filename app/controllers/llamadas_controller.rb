class LlamadasController < ApplicationController
  before_action :set_llamada, only: %i[ show edit update destroy ]

  # GET /llamadas or /llamadas.json
  def index
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

  # GET /llamadas/1 or /llamadas/1.json
  def show
  end

  # GET /llamadas/new
  def new
    @llamada = Llamada.new
  end

  # GET /llamadas/1/edit
  def edit
  end

  # POST /llamadas or /llamadas.json
  def create
    @llamada = Llamada.new(llamada_params)

    respond_to do |format|
      if @llamada.save
        format.html { redirect_to llamada_url(@llamada), notice: "Llamada was successfully created." }
        format.json { render :show, status: :created, location: @llamada }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @llamada.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /llamadas/1 or /llamadas/1.json
  def update
    respond_to do |format|
      if @llamada.update(llamada_params)
        format.html { redirect_to llamada_url(@llamada), notice: "Llamada was successfully updated." }
        format.json { render :show, status: :ok, location: @llamada }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @llamada.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /llamadas/1 or /llamadas/1.json
  def destroy
    @llamada.destroy

    respond_to do |format|
      format.html { redirect_to llamadas_url, notice: "Llamada was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_llamada
      @llamada = Llamada.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def llamada_params
      params.require(:llamada).permit(:endpoint)
    end
    
    # Apply filters to the llamadas scope
    def apply_filters(scope, filter_type)
      case filter_type
      when 'bots'
        # Simple bot detection - user agents with bot keywords or blank
        bot_patterns = %w[bot crawler spider scraper google bing yahoo facebook curl wget python java http fetch node ruby]
        scope.where(
          bot_patterns.map { |pattern| "LOWER(user_agent) LIKE ?" }.join(' OR ') + " OR user_agent IS NULL OR user_agent = ''",
          *bot_patterns.map { |pattern| "%#{pattern}%" }
        )
      when 'legitimate'
        # Exclude likely bots
        bot_patterns = %w[bot crawler spider scraper google bing yahoo facebook curl wget python java http fetch node ruby]
        scope.where.not(
          bot_patterns.map { |pattern| "LOWER(user_agent) LIKE ?" }.join(' OR ') + " OR user_agent IS NULL OR user_agent = ''",
          *bot_patterns.map { |pattern| "%#{pattern}%" }
        )
      when 'suspicious'
        # IPs with high frequency (more than 20 requests this month)
        suspicious_ips = scope.group(:ip_address).having('COUNT(*) > 20').pluck(:ip_address)
        scope.where(ip_address: suspicious_ips)
      else
        scope
      end
    end
    
    # Optimized stats calculation - cached for performance
    def calculate_monthly_stats(llamadas_scope)
      total_count = llamadas_scope.count
      
      # More efficient bot detection with single query
      bot_patterns = %w[bot crawler spider scraper google bing yahoo facebook curl wget python java http fetch node ruby]
      bot_ua_count = llamadas_scope.where(
        bot_patterns.map { |pattern| "LOWER(user_agent) LIKE ?" }.join(' OR '),
        *bot_patterns.map { |pattern| "%#{pattern}%" }
      ).count
      
      # Count blank user agents and suspicious POST requests
      blank_ua_count = llamadas_scope.where(user_agent: [nil, '']).count
      post_no_referer_count = llamadas_scope.where(request_method: 'POST', referer: [nil, '']).count
      
      # Approximate bot count (some overlap possible but faster)
      bot_count = [bot_ua_count + blank_ua_count + post_no_referer_count, total_count].min
      
      # Optimized IP analysis - limit to prevent timeout
      suspicious_ips_count = llamadas_scope.group(:ip_address)
                                           .having('COUNT(*) > 20')
                                           .limit(1000)  # Prevent massive queries
                                           .count.keys.count
      
      unique_ips_count = llamadas_scope.distinct.count(:ip_address)
      legitimate_count = total_count - bot_count
      
      {
        total_count: total_count,
        bot_count: bot_count,
        suspicious_ips_count: suspicious_ips_count,
        unique_ips_count: unique_ips_count,
        legitimate_count: legitimate_count
      }
    end
end
