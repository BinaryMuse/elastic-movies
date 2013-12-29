require 'elasticsearch'

namespace :search do
  desc 'Rebuild the search indexes'
  task :index => :environment do
    client = Elasticsearch::Client.new

    begin
      client.indices.delete index: 'movies'
    rescue => e
      puts "Could not delete index `movies`; this is normal if you have not yet created the index. Skipping deletion..."
    end
    client.indices.create index: 'movies'

    client.indices.put_mapping index: 'movies', type: 'movie', body: {
      movie: {
        properties: Movie.elastic_mapping
      }
    }

    total = Movie.count
    count = 0
    batch_size = 100
    Movie.includes([:actors, :genres, :parts]).find_in_batches(batch_size: batch_size) do |movies|
    # Movie.all.find_in_batches(batch_size: 50) do |movies|
      actions = movies.map do |movie|
        { index: { _index: 'movies', _type: 'movie', _id: movie.id, data: movie.as_elastic_json } }
      end
      client.bulk body: actions
      print "\rIndexing records #{count} - #{count + batch_size} of #{total}..."
      count += batch_size
    end

    # Movie.find_each do |movie|
    #   client.index index: 'movies', type: 'movie',
    #     id: movie.id, body: movie.as_elastic_json
    #   print '.'
    # end
    puts ''
  end
end
