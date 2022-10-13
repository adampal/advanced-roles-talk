class Account::PaymentsController < Account::ApplicationController
  account_load_and_authorize_resource :payment, through: :team, through_association: :payments

  # GET /account/teams/:team_id/payments
  # GET /account/teams/:team_id/payments.json
  def index
    delegate_json_to_api
  end

  # GET /account/payments/:id
  # GET /account/payments/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/payments/new
  def new
  end

  # GET /account/payments/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/payments
  # POST /account/teams/:team_id/payments.json
  def create
    respond_to do |format|
      if @payment.save
        format.html { redirect_to [:account, @team, :payments], notice: I18n.t("payments.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @payment] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/payments/:id
  # PATCH/PUT /account/payments/:id.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to [:account, @payment], notice: I18n.t("payments.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @payment] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/payments/:id
  # DELETE /account/payments/:id.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :payments], notice: I18n.t("payments.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  include strong_parameters_from_api

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
