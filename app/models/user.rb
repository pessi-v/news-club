class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :plan, through: :subscription
  has_one :subscription, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :readings, dependent: :destroy
  has_many :articles, through: :bookmarks
  has_many :articles, through: :readings
  validates_uniqueness_of :email
  validates_presence_of :email
  validates :first_name, :last_name, presence: true
end
