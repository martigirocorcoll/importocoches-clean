class RefreshSeoCacheJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "🚀 Starting SEO cache refresh for all brands..."

    results = SeoCacheService.refresh_all_caches

    successful = results.count { |r| r[:success] }
    failed = results.count { |r| !r[:success] }
    total_ads = results.sum { |r| r[:ads_count] || 0 }

    Rails.logger.info "✅ SEO cache refresh completed: #{successful} successful, #{failed} failed, #{total_ads} total ads"

    if failed > 0
      Rails.logger.warn "❌ Failed refreshes:"
      results.select { |r| !r[:success] }.each do |result|
        Rails.logger.warn "   - #{result[:brand]} #{result[:model]}: #{result[:error]}"
      end
    end
  end
end
