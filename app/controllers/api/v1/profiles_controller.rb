class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :read, User

    render json: current_resource_owner
  end

  def index
    authorize! :read, User

    @profiles = User.where.not(id: current_resource_owner.id)
    render json: @profiles
  end
end
