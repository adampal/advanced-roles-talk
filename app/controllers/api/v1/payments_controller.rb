class Api::V1::PaymentsController < Api::V1::ApplicationController
  account_load_and_authorize_resource :payment, through: :team, through_association: :payments

  # GET /api/v1/teams/:team_id/payments
  def index
  end

  # GET /api/v1/payments/:id
  def show
  end

  # POST /api/v1/teams/:team_id/payments
  def create
    if @payment.save
      render :show, status: :created, location: [:api, :v1, @payment]
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/payments/:id
  def update
    if @payment.update(payment_params)
      render :show
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/payments/:id
  def destroy
    @payment.destroy
  end

  private

  module StrongParameters
    # Only allow a list of trusted parameters through.
    def payment_params
      strong_params = params.require(:payment).permit(
        *permitted_fields,
        :name,
        :amount,
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
