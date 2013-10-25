require 'pp'

class SearchController < ApplicationController
  def show
    return redirect_to root_path unless params[:term].present?

    @preload_search_term = params[:term]

    search = Search.new
    search.add_multi_match(:must, [:title, :actors, :characters], params[:term], use_dis_max: false)

    if params[:genre]
      @genre = Genre.find(params[:genre])
      search.add_term(:must, 'genre_id_and_name.id', params[:genre])
    end

    if params[:year]
      @year = params[:year]
      search.add_range(:must, 'release_date', gte: "#{params[:year]}-01-01", lte: "#{params[:year]}-12-31")
    end

    if params[:budget_low]
      @budget_low = params[:budget_low].to_i
      if params[:budget_high]
        @budget_high = params[:budget_high].to_i
        search.add_range(:must, 'budget', gte: @budget_low, lte: @budget_high)
      else
        search.add_range(:must, 'budget', gte: @budget_low)
      end
    end

    search.perform!
    ids = search.results['hits']['hits'].map { |h| h['_id'] }
    # return render json: search.results

    @movies = Movie.where(id: ids).order('release_date ASC')
    
    # return render text: @movies.to_sql

    @movies = @movies.paginate(page: params[:page], per_page: 10)

    @genres = search.results['facets']['genres']['terms'].map do |term|
      { model: Genre.find_by(name: term['term']), count: term['count'] }
    end

    @years = search.results['facets']['dates']['entries'].map do |date|
      { model: Time.at(date['time'] / 1000).utc.strftime("%Y"), count: date['count'] }
    end

    @budgets = search.results['facets']['budgets']['ranges'].reject { |r| r['count'] == 0 }.map do |range|
      { from: range['from'].try(:to_i) || 0, to: range['to'].try(:to_i) || nil, count: range['count'] }
    end
    
    # pp search.results
  end
end
