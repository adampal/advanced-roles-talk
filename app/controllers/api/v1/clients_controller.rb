class Api::V1::ClientsController < Api::V1::ApplicationController
  account_load_and_authorize_resource :client, through: :team, through_association: :clients

  # GET /api/v1/teams/:team_id/clients
  def index
  end

  # GET /api/v1/clients/:id
  def show
  end

  # POST /api/v1/teams/:team_id/clients
  def create
    if @client.save
      render :show, status: :created, location: [:api, :v1, @client]
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/clients/:id
  def update
    if @client.update(client_params)
      render :show
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/clients/:id
  def destroy
    @client.destroy
  end

  private

  module StrongParameters
    # Only allow a list of trusted parameters through.
    def client_params
      strong_params = params.require(:client).permit(
        *permitted_fields,
        :team_id,
        :client_team_id,
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
