class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.monetize :amount, currency: { present: false }
      t.jsonb :payment
      t.datetime :start_date
      t.datetime :end_date
      t.references :user, foreign_key: true
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
