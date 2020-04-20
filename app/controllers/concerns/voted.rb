module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_resource, only: [:vote_up, :vote_down, :destroy_vote]
    before_action :check_author_or_voted, only: [:vote_up, :vote_down]
  end

  def vote_up
    @vote = @votable.vote_up(current_user)
    render_json('vote_up')
  end

  def vote_down
    @vote = @votable.vote_down(current_user)
    render_json('vote_down')
  end

  def destroy_vote
    @vote = current_user.vote_for(@votable)
    @vote.destroy
    render_json('destroy_vote')
  end

  private

  def render_json message
    render json: { id: @votable.id, message: message, output: render_to_string(partial: 'votes/block', locals: { data: @votable }) }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def load_resource
    @votable = model_klass.find(params[:id])
  end

  def check_author_or_voted
    head(:forbidden) if current_user.author_of?(@votable) || current_user.voted_for?(@votable)
  end
end
