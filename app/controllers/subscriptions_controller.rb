class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def create
    @question = Question.find(params[:question_id])

    @subscription = current_user.subscriptions.new(question: @question)
    authorize! :create, @subscription
    @subscription.save
  end

  def destroy
    @subscription.destroy
  end
end
