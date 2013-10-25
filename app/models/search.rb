# NOTICE: Deprecated in favor of MovieSearch; see SearchController
class Search
  attr_reader :term, :results

  def initialize()
    @client = Elasticsearch::Client.new

    @data = {
      from: 0, size: 1000,
      query: {
        bool: {},
      },
      sort: [
        { release_date: { order: 'asc' } }
      ],
      fields: [],
      facets: {
        genres: { terms: { field: 'genres', size: 20 } },
        dates: { date_histogram: { field: 'release_date', interval: 'year' } },
        budgets: { range: {
          field: 'budget',
          ranges: [
            { to: 500000 },
            { from: 500000, to: 1000000 },
            { from: 1000000, to: 10000000 },
            { from: 10000000, to: 50000000 },
            { from: 50000000, to: 100000000 },
            { from: 100000000 }
          ]
        } }
      }      
    }
  end

  def add_match(occur, field, query, operator = 'and')
    data = { match: {} }
    data[:match][field] = { query: query, operator: operator }
    @data[:query][:bool][occur] ||= []
    @data[:query][:bool][occur] << data
  end

  def add_multi_match(occur, fields, query, options = {})
    data = { multi_match: { query: query, fields: fields } }
    data[:multi_match].merge!(options)
    @data[:query][:bool][occur] ||= []
    @data[:query][:bool][occur] << data
  end

  def add_term(occur, field, value, boost = nil)
    data = { term: {} }
    data[:term][field] = { value: value }
    data[:term][field][:boost] = boost unless boost.nil?
    @data[:query][:bool][occur] ||= []
    @data[:query][:bool][occur] << data
  end

  def add_range(occur, field, range)
    data = { range: {} }
    data[:range][field] = range
    @data[:query][:bool][occur] ||= []
    @data[:query][:bool][occur] << data
  end
  
  def perform!
    pp @data
    @results = @client.search index: 'movies', body: @data
  end
end
