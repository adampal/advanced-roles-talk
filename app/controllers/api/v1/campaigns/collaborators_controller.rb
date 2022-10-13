class Api::V1::Campaigns::CollaboratorsController < Api::V1::ApplicationController
  account_load_and_authorize_resource :collaborator, through: :campaign, through_association: :collaborators

  # GET /api/v1/campaigns/:campaign_id/collaborators
  def index
  end

  # GET /api/v1/campaigns/collaborators/:id
  def show
  end

  # POST /api/v1/campaigns/:campaign_id/collaborators
  def create
    if @collaborator.save
      render :show, status: :created, location: [:api, :v1, @collaborator]
    else
      render json: @collaborator.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/campaigns/collaborators/:id
  def update
    if @collaborator.update(collaborator_params)
      render :show
    else
      render json: @collaborator.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/campaigns/collaborators/:id
  def destroy
    @collaborator.destroy
  end

  private

  module StrongParameters
    # Only allow a list of trusted parameters through.
    def collaborator_params
      strong_params = params.require(:campaigns_collaborator).permit(
        *permitted_fields,
        :campaign_id,
        :user_id,
        # 🚅 super scaffolding will insert new fields above this line.
        *permitted_arrays,
        role_ids: [],
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      process_params(strong_params)

      strong_params
    end
  end

  include StrongParameters
end
