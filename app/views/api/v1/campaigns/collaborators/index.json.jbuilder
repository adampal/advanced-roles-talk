json.data do
  json.array! @collaborators, partial: "api/v1/campaigns/collaborators/collaborator", as: :collaborator
end

render_pagination(json)
