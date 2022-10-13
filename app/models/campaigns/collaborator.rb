class Campaigns::Collaborator < ApplicationRecord
  include Roles::Support
  roles_only :admin
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :campaign
  belongs_to :user, optional: true
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :campaign
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  validates :campaign, scope: true
  validates :user, scope: true
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_campaigns
    team.campaigns
  end

  def valid_users
    team.users
  end

  # 🚅 add methods above.
end
