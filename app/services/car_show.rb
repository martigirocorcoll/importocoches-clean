class CarShow
  # class created to refactor cars/index.html.erb
  def initialize(ad_as_xml)
    @ad = ad_as_xml
  end

  ## DATOS TECNICOS ##

  def condition
    @ad.xpath('//ad:vehicle//ad:specifics//ad:condition').first.content
  end

  def first_registration_date
    @ad.xpath('//ad:vehicle//ad:specifics//ad:first-registration').attr('value').value
  end

  def gearbox
    unless @ad.xpath('//ad:vehicle//ad:specifics//ad:gearbox').empty?
      @ad.xpath('//ad:vehicle//ad:specifics//ad:gearbox').first.content
    end
  end

  def fuel
    unless @ad.xpath('//ad:vehicle//ad:specifics//ad:fuel').empty?
      @ad.xpath('//ad:vehicle//ad:specifics//ad:fuel').first.content
    end
  end

  def mileage
    @ad.xpath('//ad:vehicle//ad:specifics//ad:mileage').attr('value').value
  end

  def power
    if @ad.xpath('//ad:vehicle//ad:specifics//ad:power').empty?
      ""
    else
      @ad.xpath('//ad:vehicle//ad:specifics//ad:power').attr('value').value
    end
  end

  def cubic_capacity

  end

  def num_seats
    @ad.xpath('//ad:vehicle//ad:specifics//ad:num-seats').attr('value')&.value
  end

  def door_count
    if @ad.xpath('//ad:vehicle//ad:specifics//ad:door-count').empty?
      ""
    else
      @ad.xpath('//ad:vehicle//ad:specifics//ad:door-count').first.content
    end
  end

  def emission_sticker
    #@ad.xpath('//ad:vehicle//ad:specifics//ad:emission-sticker').first.content
  end

  def number_of_previous_owners
    if @ad.xpath('//ad:vehicle//ad:specifics//number-of-previous-owners').empty?
      return "0"
    else
     @ad.xpath('//ad:vehicle//ad:specifics//number-of-previous-owners').first.content
    end
  end

  def exterior_color
    @ad.xpath('//ad:vehicle//ad:specifics//ad:exterior-color//resource:local-description').first&.content
  end

  def category
    @ad.xpath('//ad:vehicle//ad:category//resource:local-description').first.content
  end

  def combined
    @ad.xpath('//ad:vehicle//ad:specifics//ad:emission-fuel-consumption').attr('combined')&.value
  end

  def emission_fuel_consumption
    if @ad.xpath('//ad:vehicle//ad:specifics//ad:emission-fuel-consumption').attr("co2-emission").nil?
      "Not specified"
    else
      @ad.xpath('//ad:vehicle//ad:specifics//ad:emission-fuel-consumption').attr('co2-emission').value
    end
  end

  def interior_type
    @ad.xpath('//ad:vehicle//ad:specifics//ad:interior-type//resource:local-description').first&.content
  end

  def interior_color
    unless @ad.xpath('//ad:vehicle//ad:specifics//ad:interior-color//resource:local-description').first.nil?
      @ad.xpath('//ad:vehicle//ad:specifics//ad:interior-color//resource:local-description').first.content
    end
  end

  def model_description
    @ad.xpath('//ad:vehicle//ad:model-description').attr('value').value
  end

  def make
    @ad.xpath('//ad:vehicle//ad:make//resource:local-description').first.content
  end

  def model
    @ad.xpath('//ad:vehicle//ad:model//resource:local-description').first.content
  end

  # def description
  #   description =  @ad.xpath('//ad:description')
  #   if  description.empty?
  #     ""
  #   else
  #     description.first.content
  #   end
  # end

  def modification_date
  end

  def price
  end

  def features
    @ad.xpath('//ad:vehicle//ad:features//ad:feature//resource:local-description')
  end

  def images
    imgs = []
    @ad.xpath('//ad:images//ad:image')[0...-1].each do |image|
      imgs << image.children[5].attr('url')
    end
    imgs
  end

  def description
    description =  @ad.xpath('//ad:enrichedDescription')
    if  description.empty?
      ""
    else
      description.first.content
    end
  end

  def mobile_link
    @ad.xpath('//ad:ad//ad:detail-page').attr('url').value
  end
end
