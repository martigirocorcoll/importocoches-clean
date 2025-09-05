class Car
  # class created to refactor cars/index.html.erb
  def initialize(ad_as_xml)
    @ad = ad_as_xml
  end

  def make
    @ad.xpath('ad:vehicle//ad:make//resource:local-description').first.content
  end

  def model
    unless @ad.xpath('//ad:vehicle//ad:model//resource:local-description').empty?
      @ad.xpath('//ad:vehicle//ad:model//resource:local-description').first.content
    end
  end

  def description
   if @ad.xpath('ad:vehicle//ad:model-description').attr('value').value
        @ad.xpath('ad:vehicle//ad:model-description').attr('value').value
   end
  end

  def modification_date
    @ad.xpath('ad:modification-date').attr('value').value[0..9]
  end

  def price_bruto
    @ad.xpath('ad:price//ad:consumer-price-amount').first.attr('value')
  end

  def vat
    unless @ad.xpath('ad:price//ad:vat-rate').empty?
      @ad.xpath('ad:price//ad:vat-rate').first.attr('value')
    end
  end

  def link
    @ad.xpath('ad:price//ad:consumer-price-amount').first.attr('value')
  end

  def fuel
    unless @ad.xpath('ad:vehicle//ad:specifics//ad:fuel').empty?
      @ad.xpath('ad:vehicle//ad:specifics//ad:fuel//resource:local-description').first.content
    end
  end

  def power
    unless @ad.xpath('ad:vehicle//ad:specifics//ad:power').empty?
      @ad.xpath('ad:vehicle//ad:specifics//ad:power').attr('value').value
    end
  end

  def first_registration
    unless @ad.xpath('ad:vehicle//ad:specifics//ad:first-registration').empty?
      @ad.xpath('ad:vehicle//ad:specifics//ad:first-registration').attr('value').value
    end
    end

  def gearbox
    unless  @ad.xpath('ad:vehicle//ad:specifics//ad:gearbox').empty?
     @ad.xpath('ad:vehicle//ad:specifics//ad:gearbox//resource:local-description').first.content
    end
  end

  def color
    unless @ad.xpath('ad:vehicle//ad:specifics//ad:exterior-color//resource:local-description').empty?
      "Color #{@ad.xpath('ad:vehicle//ad:specifics//ad:exterior-color//resource:local-description').first.content}"
    end
  end

  def door
    unless @ad.xpath('ad:vehicle//ad:specifics//ad:door-count').empty?
      ", Número de puertas: #{@ad.xpath('ad:vehicle//ad:specifics//ad:door-count//resource:local-description').first.content}"
    end
  end

  def category
    unless  @ad.xpath('ad:vehicle//ad:category//resource:local-description').empty?
      @ad.xpath('ad:vehicle//ad:category//resource:local-description').first.content
    end
  end

  def mileage
    unless  @ad.xpath('ad:vehicle//ad:specifics//ad:mileage').empty?
      @ad.xpath('ad:vehicle//ad:specifics//ad:mileage').attr('value').value
    end
  end

  def photo
       @ad.xpath('ad:images//ad:image//ad:representation')[3]
  end
end
