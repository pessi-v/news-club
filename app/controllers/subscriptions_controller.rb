class SubscriptionsController < ApplicationController

  def new
    @plan1 = Plan.find(1)
    @plan2 = Plan.find(2)
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new

  end

  private

  def subscription_params
    params.require(:subscription).permit(:plan_id, :user_id)
  end
end
