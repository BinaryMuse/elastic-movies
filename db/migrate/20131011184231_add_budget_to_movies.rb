class AddBudgetToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :budget, :integer
  end
end
