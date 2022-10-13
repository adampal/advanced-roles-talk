json.data do
  json.array! @payments, partial: "api/v1/payments/payment", as: :payment
end

render_pagination(json)
