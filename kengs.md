# whenever
> this gem is used to make job do periodly
see https://github.com/javan/whenever

if you can not run `whenever` command
try `bundle exec whenever`

run `whenever --update-crontab` to write task...
caution for environment, seems default is production..

# postgre sql
see https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-ubuntu-14-04

## install pgsql
>   sudo apt-get update
>   sudo apt-get install postgresql postgresql-contrib libpq-dev

## create database user
>   sudo -u postgres createuser -s jsd
>   sudo -u postgres psql
>   \password jsd
>   ***new password*** => jsd
>   \q

username=`jsd` passwd=`jsd`

## config database connection
`config/database.yml`
>   host: localhost
>   adapter: postgresql
>   encoding: utf8
>   database: jsd
>   pool: 5
>   username: jsd
>   password: jsd

database=`jsd`

## create production database
> rake db:create RAILS_ENV=production
> rake db:migrate RAILS_ENV=production
> rake db:seed RAILS_ENV=production


