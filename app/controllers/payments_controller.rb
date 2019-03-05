class PaymentsController < ApplicationController

  before_action :set_subscription

  def new
  end

  def create
    customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
      )

    charge = Stripe::Charge.create(
      customer:     customer.id,  # You should store this customer id and re-use it.
      amount:       @subscription.amount_cents,
      description:  "Payment for plan #{@subscription} for plan #{@subscription.id}",
      currency:     @subscription.amount.currency
    )

    # @order.update(payment: charge.to_json, state: 'paid')
    redirect_to root_path
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to new_order_payment_path(@order)
  end

  private

  def set_subscription
    @subscription = current_user.subscription
  end
end
