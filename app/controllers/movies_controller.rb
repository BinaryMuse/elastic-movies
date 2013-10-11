class MoviesController < ApplicationController
  respond_to :json, :html

  def index
    @movies = Movie.paginate(page: params[:page], per_page: 10)
    respond_with @movies
  end

  def show
    @movie = Movie.find params[:id]
    respond_with @movie
  end
end
