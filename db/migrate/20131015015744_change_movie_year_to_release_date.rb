class ChangeMovieYearToReleaseDate < ActiveRecord::Migration
  def change
    change_table :movies do |t|
      t.datetime :release_date
    end
    remove_column :movies, :year
  end
end
