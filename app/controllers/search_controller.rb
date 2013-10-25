require 'pp'

class SearchController < ApplicationController
  def show
    return redirect_to root_path unless params[:term].present?

    search = MovieSearch.new(params)

    @preload_search_term = params[:term]
    @genre = Genre.find(params[:genre]) if params[:genre]
    @year = params[:year] if params[:year]
    @budget_low = params[:budget_low].to_i if params[:budget_low]
    @budget_high = params[:budget_high].to_i if params[:budget_high]

    results = search.perform

    ids = results['hits']['hits'].map { |h| h['_id'] }

    @movies = Movie.where(id: ids).order('release_date ASC')
    
    @movies = @movies.paginate(page: params[:page], per_page: 10)

    # Build up the arrays that facilitate facet navigation

    @genres = results['facets']['genres']['terms'].map do |term|
      { model: Genre.find_by(name: term['term']), count: term['count'] }
    end

    @years = results['facets']['dates']['entries'].map do |date|
      { model: Time.at(date['time'] / 1000).utc.strftime("%Y"), count: date['count'] }
    end

    @budgets = results['facets']['budgets']['ranges'].reject { |r| r['count'] == 0 }.map do |range|
      { from: range['from'].try(:to_i) || 0, to: range['to'].try(:to_i) || nil, count: range['count'] }
    end
    
    # pp search.results
  end
end
