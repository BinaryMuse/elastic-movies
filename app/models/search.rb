class Search
  attr_reader :term, :results

  def initialize()
    @client = Elasticsearch::Client.new

    @data = {
      from: 0, size: 1000,
      query: {
        bool: {
          must: []
          # match: { _all: @term }

          # query_string: {
          #   default_operator: 'AND',
          #   query: @term
          # }

          # match: {
          #   title: {
          #     query: @term,
          #     operator: 'and'
          #   }
          # }
        },
      },
      sort: [
        { release_date: { order: 'asc' } }
      ],
      fields: [],
      facets: {
        genres: { terms: { field: 'genres', size: 20 } },
        dates: { date_histogram: { field: 'release_date', interval: 'year' } }
      }      
    }
  end

  def add_match(field, query, operator = 'and')
    data = { match: {} }
    data[:match][field] = { query: query, operator: operator }
    @data[:query][:bool][:must] << data
  end
  
  def add_term(field, value, boost = nil)
    Rails.logger.info "adding term #{field}, #{value}"

    data = { term: {} }
    data[:term][field] = { value: value }
    data[:term][field][:boost] = boost unless boost.nil?
    @data[:query][:bool][:must] << data
  end
  
  def perform!
    pp @data
    @results = @client.search index: 'movies', body: @data
  end
end
