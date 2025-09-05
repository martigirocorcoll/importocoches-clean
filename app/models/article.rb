class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :titulo, use: :slugged
  has_rich_text :content
end
