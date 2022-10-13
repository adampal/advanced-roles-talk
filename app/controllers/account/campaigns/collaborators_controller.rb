class Account::Campaigns::CollaboratorsController < Account::ApplicationController
  account_load_and_authorize_resource :collaborator, through: :campaign, through_association: :collaborators

  # GET /account/campaigns/:campaign_id/collaborators
  # GET /account/campaigns/:campaign_id/collaborators.json
  def index
    delegate_json_to_api
  end

  # GET /account/campaigns/collaborators/:id
  # GET /account/campaigns/collaborators/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/campaigns/:campaign_id/collaborators/new
  def new
  end

  # GET /account/campaigns/collaborators/:id/edit
  def edit
  end

  # POST /account/campaigns/:campaign_id/collaborators
  # POST /account/campaigns/:campaign_id/collaborators.json
  def create
    respond_to do |format|
      if @collaborator.save
        format.html { redirect_to [:account, @campaign, :collaborators], notice: I18n.t("campaigns/collaborators.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @collaborator] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/campaigns/collaborators/:id
  # PATCH/PUT /account/campaigns/collaborators/:id.json
  def update
    respond_to do |format|
      if @collaborator.update(collaborator_params)
        format.html { redirect_to [:account, @collaborator], notice: I18n.t("campaigns/collaborators.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @collaborator] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/campaigns/collaborators/:id
  # DELETE /account/campaigns/collaborators/:id.json
  def destroy
    @collaborator.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @campaign, :collaborators], notice: I18n.t("campaigns/collaborators.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  include strong_parameters_from_api

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
