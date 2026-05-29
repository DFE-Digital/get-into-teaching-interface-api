class CreateIntegrations < ActiveRecord::Migration[8.1]
  def change
    create_table :integrations do |t|
      t.string :name, null: false
      t.index :name, unique: true

      t.timestamps
    end
  end
end
