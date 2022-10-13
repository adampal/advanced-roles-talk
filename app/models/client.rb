class Client < ApplicationRecord
  include Roles::Support
  roles_only :admin
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :team
  belongs_to :client_team, class_name: "Team", optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :team, scope: true
  validates :client_team, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_teams
    Team.all
  end

  def valid_client_teams
    Team.all
  end

  def invalidate_cache
    team.users.map(&:invalidate_ability_cache)
  end

  # 🚅 add methods above.
end
