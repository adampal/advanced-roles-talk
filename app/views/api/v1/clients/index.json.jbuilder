json.data do
  json.array! @clients, partial: "api/v1/clients/client", as: :client
end

render_pagination(json)
