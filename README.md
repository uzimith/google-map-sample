map sinatra
====

## Install

```
bundle install
bundle exec rake db:migrate
```

## Usage

```
ruby app.rb
```

Open `localhost:3000` in your web-browser

## Support

### bundle install --without
    bundle install --without production

### migrate
    rake db:create_migration NAME=create_posts

### herokuについて
    heroku addons:add heroku-postgresql
