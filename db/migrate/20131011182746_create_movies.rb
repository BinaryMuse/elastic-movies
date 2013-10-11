class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :year
      t.integer :external_id

      t.timestamps
    end
  end
end
