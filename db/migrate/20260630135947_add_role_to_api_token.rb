class AddRoleToAPIToken < ActiveRecord::Migration[8.1]
  def change
    add_column :api_tokens, :role, :string, null: false
  end
end
