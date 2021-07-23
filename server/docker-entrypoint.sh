#!/bin/sh

/usr/local/bin/bundle exec rails db:create
/usr/local/bin/bundle exec rails db:apply
/usr/local/bin/bundle exec rails s -b 0.0.0.0
