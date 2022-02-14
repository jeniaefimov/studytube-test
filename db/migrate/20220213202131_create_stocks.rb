class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.references :bearer, index: true, null: false, foreign_key: true
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
