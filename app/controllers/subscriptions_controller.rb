class SubscriptionsController < ApplicationController

  def new
    @plan1 = Plan.find(1)
    @plan2 = Plan.find(2)
    @subscription = Subscription.new

  end

  def create
    @plan = Plan.find(params[:plan_id])
    @subscription = Subscription.create!(amount_cents: @plan.price_cents, user: current_user, plan: @plan)
    redirect_to new_subscription_payment_path(@subscription)

  end

  private

  def subscription_params
    params.require(:subscription).permit(:plan_id, :user_id)
  end
end
