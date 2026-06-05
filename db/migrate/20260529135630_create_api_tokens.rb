class CreateAPITokens < ActiveRecord::Migration[8.1]
  def change
    create_table :api_tokens do |t|
      t.string :hashed_token, null: false
      t.datetime :last_used_at, precision: nil
      t.references :integration, null: false, foreign_key: true
      t.index :hashed_token, unique: true

      t.timestamps
    end
  end
end
