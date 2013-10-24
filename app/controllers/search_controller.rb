require 'pp'

class SearchController < ApplicationController
  def show
    return redirect_to root_path unless params[:term].present?

    @preload_search_term = params[:term]

    search = Search.new
    search.add_match(:title, params[:term])

    if params[:genre]
      @genre = Genre.find(params[:genre])
      search.add_term('genre_id_and_name.id', params[:genre])
    end

    search.perform!
    ids = search.results['hits']['hits'].map { |h| h['_id'] }
    # return render json: search.results

    @movies = Movie.where(id: ids).order('release_date ASC')

    # if params[:genre]
    #   @genre = Genre.find(params[:genre])
    #   @movies = @movies.includes(:genres).where(:genres => { id: params[:genre] })
    # end

    if params[:year]
      @year = params[:year]
      start = "#{@year}-01-01"
      finish = "#{@year}-12-31" 
      @movies = @movies.where('release_date >= ? AND release_date <= ?', start, finish)
    end
    
    # return render text: @movies.to_sql

    @movies = @movies.paginate(page: params[:page], per_page: 10)

    @genres = search.results['facets']['genres']['terms'].map do |term|
      { model: Genre.find_by(name: term['term']), count: term['count'] }
    end

    @years = search.results['facets']['dates']['entries'].map do |date|
      { model: Time.at(date['time'] / 1000).utc.strftime("%Y"), count: date['count'] }
    end
    
    # pp search.results
  end
end
