class CreateBuyItems < ActiveRecord::Migration[5.1]
  def change
    create_table :buy_items do |t|
      t.string :name
      t.string :description
      t.references :buylist, foreign_key: true

      t.timestamps
    end
  end
end
