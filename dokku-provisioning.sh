dokku apps:create klausurarchiv

dokku plugin:install https://github.com/dokku/dokku-postgres.git

dokku postgres:create klausurarchiv

dokku postgres:link klausurarchiv klausurarchiv

dokku domains:set klausurarchiv klausurarchiv.fachschaft-wiwi.ms

dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
dokku config:set --global DOKKU_LETSENCRYPT_EMAIL=admin@fachschaft-wiwi.ms

# enable letsencrypt
dokku letsencrypt:enable klausurarchiv

# enable auto-renewal
dokku letsencrypt:cron-job --add


# dokku env:set klausurarchiv
# Set followin environment variables
#   HOST
#   PORT
#   SECRET_KEY_BASE
#   JWT_SECRET
