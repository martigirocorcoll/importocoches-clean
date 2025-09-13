class PriceCalculation

  def initialize(args = {})
    @transporte = 1200
    @tasas = 600
    @margen_bruto = 0.02
    @margen_bruto_reduced = 0.005
    @primera_matriculacion = :first_registration == nil ? Date.strptime(args[:first_registration], '%Y-%m') : 0
    @price_bruto = args[:price_bruto].to_f
    @vat = args[:vat].to_f
  end


  def finalprice
    return (pricees + @tasas + @transporte + banco + beneficio)
  end

  def finalpricereduced
    return (pricees + @tasas + @transporte + banco + beneficioreduced)
  end

  private

  def garantia
    # la garantia només cal ferla si el cotxe que s'importa té més de 14 mesos (420 dies) i val 650€. Si no, es gratis perquè el cotxe ja en porta.
    # Date.today - DateTime.parse(@primera_matriculacion) > 420 ? 650 : 0
    unless @primera_matriculacion == 0
      Date.today - @primera_matriculacion > 420 ? 650 : 0
    else
      650
    end
  end

  def pricees
    return @price_bruto
  end

  def pricees_dedu
    return @price_bruto / (1+@vat) * (1.21)
  end

  def banco
    return @price_bruto * 0.004
  end

  def beneficio
    if ((1000 + @margen_bruto * @price_bruto) * 1.21).to_i < 1200
      return 1200
    else
      return ((1000 + @margen_bruto * @price_bruto) * 1.21).to_i
    end
  end

  def beneficioreduced
    if ((1000 + @margen_bruto_reduced * @price_bruto )* 1.21).to_i < 750
      return 750
    else
      return ((1000 + @margen_bruto_reduced * @price_bruto )* 1.21).to_i
    end
  end
end
