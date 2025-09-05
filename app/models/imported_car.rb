class ImportedCar < ApplicationRecord
  has_one_attached :ficha_pdf
  has_rich_text :long_description_es
  has_rich_text :long_description_en
  has_rich_text :long_description_cat
  has_rich_text :long_description_fr

  # 1) Paginación: 10 ítems por página
  paginates_per 10

  # Slug generation
  before_save :generate_slug
  validates :slug, presence: true, uniqueness: true

  # 2) Helper para obtener la descripción según el locale actual
  def long_description_for(locale = I18n.locale)
    public_send("long_description_#{locale}") || ""
  end

  # 3) (Opcional) Normalizar URLs: eliminar líneas en blanco y espacios
  before_save do
    %i[ad_image_urls video_urls].each do |field|
      cleaned = public_send(field).to_s.lines.map(&:strip).reject(&:blank?)
      public_send("#{field}=", cleaned.join("\n"))
    end
  end

  def to_param
    slug
  end

  private

  def generate_slug
    return if brand.blank? || model.blank?
    
    base_slug = "#{brand.downcase}-#{model.downcase}".parameterize
    
    # Check for duplicates and add number if needed
    counter = 1
    new_slug = base_slug
    
    while ImportedCar.where(slug: new_slug).where.not(id: id).exists?
      new_slug = "#{base_slug}-#{counter}"
      counter += 1
    end
    
    self.slug = new_slug
  end
end
