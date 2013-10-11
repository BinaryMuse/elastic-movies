class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.integer :movie_id
      t.integer :actor_id
      t.string :character

      t.timestamps
    end
  end
end
