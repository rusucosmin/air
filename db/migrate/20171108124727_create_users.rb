class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: true, unique: true
      t.string :password_digest
      t.integer :role, null: false, default: 0

      t.timestamps
    end
  end
end
