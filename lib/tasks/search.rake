require 'elasticsearch'

namespace :search do
  desc 'Rebuild the search indexes'
  task :index => :environment do
    client = Elasticsearch::Client.new

    client.indices.delete index: '_all'
    client.indices.create index: 'movies'

    client.indices.put_mapping index: 'movies', type: 'movie', body: {
      movie: {
        properties: Movie.elastic_mapping
      }
    }

    Movie.all.find_in_batches(batch_size: 50) do |movies|
      actions = movies.map do |movie|
        { index: { _index: 'movies', _type: 'movie', _id: movie.id, data: movie.as_elastic_json } }
      end
      client.bulk body: actions
      print '.'
    end

    # Movie.find_each do |movie|
    #   client.index index: 'movies', type: 'movie',
    #     id: movie.id, body: movie.as_elastic_json
    #   print '.'
    # end
    puts ''
  end
end
