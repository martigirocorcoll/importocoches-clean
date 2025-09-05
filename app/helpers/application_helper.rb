module ApplicationHelper
  def hreflang_tags
    map     = Rails.configuration.x.hreflang_map
    default = Rails.configuration.x.hreflang_default
    base_url = "https://www.importocotxe.ad"
    current_path = request.path

    # Special handling for articles
    if current_path.start_with?('/articles')
      # Individual article pages don't have language versions
      if current_path.match?(/^\/articles\/\d+/) || current_path.match?(/^\/articles\/[^\/]+$/)
        tags = [tag.link(rel: "alternate", hreflang: "x-default", href: "#{base_url}#{current_path}")]
        return safe_join(tags, "\n")
      end

      # Articles index page has language versions using query params
      if current_path == '/articles'
        tags = map.map do |locale, code|
          if locale == default
            href = "#{base_url}#{current_path}"
          else
            href = "#{base_url}#{current_path}?locale=#{locale}"
          end
          tag.link(rel: "alternate", hreflang: code, href: href)
        end

        # x-default points to the default language version (without query param)
        tags << tag.link(rel: "alternate", hreflang: "x-default", href: "#{base_url}#{current_path}")
        return safe_join(tags, "\n")
      end
    end

    # Remove locale prefix from current path if present
    clean_path = current_path
    map.keys.each do |locale|
      next if locale == default
      if current_path.start_with?("/#{locale}")
        clean_path = current_path.sub("/#{locale}", "")
        break
      end
    end

    # Ensure clean_path starts with / and handle root case
    clean_path = "/" if clean_path.empty?
    clean_path = "/#{clean_path}" unless clean_path.start_with?("/")

    tags = map.map do |locale, code|
      if locale == default
        href = clean_path == "/" ? "#{base_url}/" : "#{base_url}#{clean_path}"
      else
        href = clean_path == "/" ? "#{base_url}/#{locale}" : "#{base_url}/#{locale}#{clean_path}"
      end
      tag.link(rel: "alternate", hreflang: code, href: href)
    end

    # x-default points to the default language version
    x_default_href = clean_path == "/" ? "#{base_url}/" : "#{base_url}#{clean_path}"
    tags << tag.link(rel: "alternate", hreflang: "x-default", href: x_default_href)

    safe_join(tags, "\n")
  end

  # WhatsApp numbers for different countries
  def whatsapp_spain_number
    "+34663308330"
  end

  def whatsapp_spain_url(message = "")
    encoded_message = CGI.escape(message) unless message.empty?
    "https://wa.me/#{whatsapp_spain_number}#{'?text=' + encoded_message unless message.empty?}"
  end
end
