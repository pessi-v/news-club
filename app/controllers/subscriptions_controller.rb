class SubscriptionsController < ApplicationController

  def new
    @subscription = Subscription.new
  end

  private

  def subscription_params
    params.require(:subscription).permit(:plan_id, :user_id)
  end
end
