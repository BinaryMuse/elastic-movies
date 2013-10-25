Elasticsearch Movies
====================

This project was built to test Elasticsearch. It performs searches against a database of 2000 of the top movies according to [The Movie DB](themoviedb.org).

Installation
------------

First, follow the normal Rails application steps:

```bash
bundle install # install gems
rake db:create db:schema:load # create the DB and load the schema
```

If you have an API key for [The Movie DB's API](http://www.themoviedb.org/documentation/api), you can run the following command to populate the database:

```bash
MOVIEDB_API_KEY="my_api_key" rake movies:populate
```

To save some time, the IDs for the top 2000 movies are hardcoded; see `lib/tasks/movies.rake` for more information.

If you do *not* have an API key, you can download an SQLite database preloaded with the data from [the repo's releases page](https://github.com/BinaryMuse/elastic-movies/releases). Simply drop it into `db/` with the name `development.sqlite3`.