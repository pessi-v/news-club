class Article < ApplicationRecord
  acts_as_taggable
  has_many :bookmarks
  has_many :readings
  has_many :users, through: :bookmarks
  has_many :users, through: :readings
  validates_presence_of :title, :author, :source
  validates_uniqueness_of :title
end
