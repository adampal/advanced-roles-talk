json.data do
  json.array! @campaigns, partial: "api/v1/campaigns/campaign", as: :campaign
end

render_pagination(json)
