class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
