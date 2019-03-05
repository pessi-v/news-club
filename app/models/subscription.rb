class Subscription < ApplicationRecord
  monetize :amount_cents
  belongs_to :user
  belongs_to :plan
end
