class AddDiscardedAtToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :discarded_at, :datetime, index: true
  end
end
