class PriceCalculation

  def initialize(args = {})
    @transporte = 1300
    @tasas = 750
    @margen_bruto = 0.06
    @margen_bruto_reduced = 0.03
    @primera_matriculacion = :first_registration == nil ? Date.strptime(args[:first_registration], '%Y-%m') : 0
    @price_bruto = args[:price_bruto].to_f
    @vat = args[:vat].to_f
  end

  def finalprice
    return (pricead + @tasas + @transporte + banco + beneficio + garantia)
  end

  def finalpricereduced
    return (pricead + @tasas + @transporte + banco + beneficioreduced)
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

  def pricead
    return @price_bruto / (1+@vat) * (1.045)
  end

  def banco
    return @price_bruto * 0.0042
  end

  def beneficio
    if (@margen_bruto * @price_bruto * 1.045).to_i < 1500
      return 1500
    else
      return (@margen_bruto * @price_bruto * 1.045).to_i
    end
  end

  def beneficioreduced
    if (@margen_bruto_reduced * @price_bruto * 1.045).to_i < 650
      return 650
    else
      return (@margen_bruto_reduced * @price_bruto * 1.045).to_i
    end
  end
end
