class AddPublisherIdToBooks < ActiveRecord::Migration[6.1]
  def change
    add_reference :books, :publisher, foreign_key: true
    change_column :books, :publisher_id, :integer, null: false # SQLite3で動く形に修正した
  end
end
