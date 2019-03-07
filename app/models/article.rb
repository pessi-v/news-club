class Article < ApplicationRecord
  acts_as_taggable
  has_many :bookmarks
  has_many :readings
  has_many :users, through: :bookmarks
  has_many :users, through: :readings
  validates_presence_of :title, :author, :source, :url
  validates_uniqueness_of :title, :url

  CATEGORIES = ["general", "technology", "business", "sports", "entertainment", "health", "science"].freeze
end
