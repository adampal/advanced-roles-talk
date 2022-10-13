class Api::V1::CampaignsController < Api::V1::ApplicationController
  account_load_and_authorize_resource :campaign, through: :team, through_association: :campaigns

  # GET /api/v1/teams/:team_id/campaigns
  def index
  end

  # GET /api/v1/campaigns/:id
  def show
  end

  # POST /api/v1/teams/:team_id/campaigns
  def create
    if @campaign.save
      render :show, status: :created, location: [:api, :v1, @campaign]
    else
      render json: @campaign.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/campaigns/:id
  def update
    if @campaign.update(campaign_params)
      render :show
    else
      render json: @campaign.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/campaigns/:id
  def destroy
    @campaign.destroy
  end

  private

  module StrongParameters
    # Only allow a list of trusted parameters through.
    def campaign_params
      strong_params = params.require(:campaign).permit(
        *permitted_fields,
        :name,
        # 🚅 super scaffolding will insert new fields above this line.
        *permitted_arrays,
        # 🚅 super scaffolding will insert new arrays above this line.
      )

      process_params(strong_params)

      strong_params
    end
  end

  include StrongParameters
end
