class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.string :session_id
      t.datetime :abandoned_at

      t.timestamps
    end
  end
end
