class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.references :team, null: false, foreign_key: true
      t.references :client_team, null: true, foreign_key: {to_table: "teams"}
      t.jsonb :role_ids

      t.timestamps
    end
  end
end
