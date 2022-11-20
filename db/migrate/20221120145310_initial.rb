class Initial < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :login, null: false
      t.string :token_digest

      t.timestamps
    end

    create_table :wallets do |t|
      t.string :hashed_id, null: false, index: { unique: true }
      t.references :user, null: false, foreign_key: true, index: true, on_delete: :cascade

      t.timestamps
    end
  end
end
