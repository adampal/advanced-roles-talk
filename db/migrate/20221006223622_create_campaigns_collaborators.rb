class CreateCampaignsCollaborators < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns_collaborators do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.jsonb :role_ids

      t.timestamps
    end
  end
end
