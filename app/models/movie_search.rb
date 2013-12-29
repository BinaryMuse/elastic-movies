class MovieSearch
  def initialize(params)
    @search = Tire::Search::Search.new 'movies' do |s|
      s.from 0
      s.size 1000
      s.fields []

      s.query do |q|
        q.boolean do |b|
          b.must do |m|
            m.boolean do |sub|
              sub.should { |m| m.match 'title', params[:term], operator: 'and' }
              sub.should { |m| m.match 'actors', params[:term], type: 'phrase' }
              sub.should { |m| m.match 'characters', params[:term], type: 'phrase' }
            end
          end
          b.must { |m| m.term 'genre_id_and_name.id', params[:genre] } if params[:genre]
          b.must { |m| m.range 'release_date', gte: "#{params[:year]}-01-01", lte: "#{params[:year]}-12-31" } if params[:year]
          if params[:budget_low] && params[:budget_high]
            b.must { |m| m.range 'budget', gte: params[:budget_low], lte: params[:budget_high] }
          elsif params[:budget_low]
            b.must { |m| m.range 'budget', gte: params[:budget_low] }
          end
        end
      end

      s.sort { by 'release_date', 'asc' }

      s.facet 'genres' do
        terms 'genres', size: 20
      end

      s.facet 'dates' do
        date 'release_date', interval: 'year'
      end

      s.facet 'budgets' do
        range 'budget', [
          { to: 500000 },
          { from: 500000, to: 1000000 },
          { from: 1000000, to: 10000000 },
          { from: 10000000, to: 50000000 },
          { from: 50000000, to: 100000000 },
          { from: 100000000 }
        ]
      end
    end
  end

  def perform
    @results ||= begin
      client = Elasticsearch::Client.new
      client.search index: 'movies', body: @search.to_hash
    end
  end
end
