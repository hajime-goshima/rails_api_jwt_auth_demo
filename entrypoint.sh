#!/bin/sh
rm -rf tmp/pids/server.pid
bundle exec rails s -p 3001 -b '0.0.0.0'
