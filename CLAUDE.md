# Claude Code Session - Importocotxe.ad API Optimization

## Project Overview
**Importocotxe.ad** - Ruby on Rails car import business from Germany to Andorra
- Uses mobile.de API (costs per request)
- Multi-language support (ES, FR, EN, CAT, RU, DE, NL)
- Supports luxury brands: BMW, Mercedes, Porsche, Audi, VW, Mini, Cupra, Tesla, Lamborghini

## Current API Protection System
**Existing 5-search limit system:**
- `session[:api_counter]` tracks API usage
- Anonymous users: 5 free searches, then must login
- Registered users: unlimited searches
- UI checks: `<% if session[:api_counter]<5 || user_signed_in? %>`
- Counter incremented in `cars_controller.rb` lines 36, 49, 112

## Identified Vulnerabilities

### Critical Issues
1. **Direct API Endpoint Access** - Bots can POST directly to `/cars` bypassing UI checks
2. **Session Reset Bypass** - Clearing cookies resets counter to 0
3. **Car Detail Pages Unprotected** - `/car?id=123` makes API calls without session checks
4. **Pagination Endpoint Vulnerable** - `/car-page` bypasses session limits

### Medium Issues
- No IP-based rate limiting
- No request frequency limits  
- Predictable session behavior
- API logging only (after the fact)

## Implemented Security Solutions ✅

### ✅ COMPLETED - Bot Protection (July 16, 2025)
1. **rack-attack gem installed and configured**
   - 20 searches/hour per IP for `/cars` endpoints
   - 30 car views/hour per IP for `/car` endpoint
   - 50 pagination/hour per IP for `/car-page`
   - 5 same-car views per 30 minutes (prevents spam viewing)
   - 100 total requests/hour global limit per IP
   - Auto-ban after 3 rate limit violations for 1 hour
   - Logged-in users whitelisted (bypass all limits)

2. **Enhanced Llamada model with bot detection**
   - Added fields: `ip_address`, `user_agent`, `referer`, `session_id`, `country`, `request_method`
   - Bot detection methods: `bot_user_agent?`, `suspicious_frequency?`, `likely_bot?`
   - Analysis tools: `bot_requests_today`, `top_ips_today`, `suspicious_ips`
   - Full logging in `cars_controller.rb` and `pages_controller.rb`

3. **Professional error pages with lead generation**
   - Custom 404, 422, 500, and 429 pages with Clientify contact forms
   - Mobile-responsive design with clear explanations
   - Convert errors into business opportunities

### 🔄 IN PROGRESS - SEO Caching
- Need to implement weekly caching for SEO pages (70% cost reduction)
- 50+ brand/model pages making uncached API calls to mobile.de

### 📋 PENDING - Additional Improvements
1. Move session validation to controller level with `before_action :check_api_limit`
2. Add centralized API limit check in `application_controller.rb`
3. Add CSRF protection with `protect_from_forgery`
4. Complete logging for all SEO pages in `pages_controller.rb`
5. Implement smart search result caching (2-hour cache for popular searches)

## SEO Pages Caching Strategy

### Problem
SEO model pages (BMW X5, Mercedes CLA, etc.) make API calls that:
- Cost money for each bot/crawler visit
- Are accessed by Google, Bing, and other search engines
- Don't need real-time data for SEO purposes

### Solution: Weekly Caching System
**Key files to modify:**
- `app/controllers/pages_controller.rb` - Methods like `set_bmw`, `set_mercedes`, `set_audi`
- All brand model pages: `/marca/bmw-andorra/x5`, `/marca/mercedes-andorra/cla`, etc.

**Implementation:**
1. Create `SeoCacheService` for weekly data caching
2. Update controller methods to use cached data instead of API calls
3. Create `SeoCacheRefreshJob` for weekly updates
4. Add manual cache management tools

**Expected Impact:**
- 70-80% reduction in API costs
- Zero API calls from search engine crawlers
- Faster page loads for SEO pages
- Weekly fresh data updates

## User Engagement Strategies

### Window Shopping Problem
Legitimate users search extensively but aren't ready to buy, consuming API costs.

### Solutions Identified
1. **Tiered Access**: Different limits based on engagement (registered: 25, interested: 50, premium: unlimited)
2. **Smart Caching**: Cache popular search combinations for 2 hours
3. **Engagement Rewards**: More searches for contact form fills, newsletter signup, etc.
4. **Alternative Content**: Show sample results without API calls
5. **Saved Searches**: Convert repeated searches into email alerts
6. **Premium Subscriptions**: Monthly plans for unlimited searches
7. **User Segmentation**: Different strategies for casual vs serious buyers

## File Structure Analysis

### Key Controllers
- `app/controllers/cars_controller.rb` - Main search functionality, API calls
- `app/controllers/pages_controller.rb` - SEO pages, brand/model pages

### Key Services  
- `app/services/api_caller.rb` - Handles mobile.de API requests
- `app/services/car_search.rb` - Builds API endpoints with filters
- `app/services/price_calculation.rb` - Calculates final prices

### Key Models
- `app/models/llamada.rb` - Logs all API requests
- `app/models/contact.rb` - User inquiries
- `app/models/user.rb` - User authentication (Devise)

### Routes
- Search: `POST /cars` (currently vulnerable)
- Car detail: `GET /car` (currently vulnerable)
- Pagination: `GET /car-page` (currently vulnerable)
- SEO pages: `GET /marca/{brand}-andorra/{model}` (high API cost)

## Next Steps Priority

### Immediate (Week 1)
1. Implement SEO caching system for top 5 brand pages
2. Add controller-level session validation
3. Add CSRF protection

### Short-term (Week 2-3)
1. Complete SEO caching for all model pages
2. Implement IP-based rate limiting
3. Add bot detection mechanisms

### Medium-term (Month 2)
1. User engagement reward system
2. Smart search caching
3. Monitoring dashboard

## Testing Commands
```bash
# Check API request logs with new fields
rails console
> Llamada.where(created_at: Date.current.all_day).count
> Llamada.bot_requests_today.count
> Llamada.top_ips_today
> Llamada.suspicious_ips

# Test bot detection
> l = Llamada.last
> l.bot_user_agent?
> l.suspicious_frequency?
> l.likely_bot?

# Clear SEO caches (when implemented)
rails seo_cache:clear

# Refresh SEO caches manually (when implemented)
rails seo_cache:refresh
```

## Environment Variables
- `MOBILE_API_KEY` - mobile.de API authentication

## Current Session Logic
```ruby
# pages_controller.rb
def set_api_counter
  session[:api_counter] = 0 if session[:api_counter].nil?
end

# cars_controller.rb  
unless session[:api_counter].nil?
  session[:api_counter] += 1
end
```

## Implementation Status

### ✅ COMPLETED (July 16, 2025)
- [x] Install rack-attack gem for IP rate limiting
- [x] Configure rate limits for all vulnerable endpoints
- [x] Enhance Llamada model with bot detection fields and methods
- [x] Update controllers to log full request data
- [x] Create professional error pages (404, 422, 500, 429) with contact forms
- [x] Test and verify all configurations work properly

### 🔄 NEXT SESSION PRIORITIES
- [ ] Implement SEO page caching (70% cost reduction priority)
- [ ] Create `SeoCacheService` for weekly data refresh
- [ ] Update all brand controller methods to use cached data
- [ ] Create weekly refresh job for automated cache updates
- [ ] Add manual cache management tools
- [ ] Complete logging for remaining SEO pages
- [ ] Test with main brand pages and deploy to production

### 📊 CURRENT IMPACT
- **Bot protection**: Active with rack-attack middleware
- **API cost reduction**: Immediate protection from 599-request bot attacks
- **Lead generation**: Error pages now capture potential customers
- **Monitoring**: Enhanced logging reveals bot patterns and attack sources