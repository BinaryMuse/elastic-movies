class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.integer :movie_id
      t.integer :genre_id

      t.timestamps
    end
  end
end
