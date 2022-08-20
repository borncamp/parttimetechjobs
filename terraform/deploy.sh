#!/bin/bash
db_user=`az keyvault secret show --vault-name jobsrailsapp --name db-username |grep value|sed -e 's/.*\"\(.*\)\"/\1/'`
db_password=`az keyvault secret show --vault-name jobsrailsapp --name db-password |grep value|sed -e 's/.*\"\(.*\)\"/\1/'`
db_host=`az keyvault secret show --vault-name jobsrailsapp --name db-host |grep value|sed -e 's/.*\"\(.*\)\"/\1/'`
db_database=`az keyvault secret show --vault-name jobsrailsapp --name db-database |grep value|sed -e 's/.*\"\(.*\)\"/\1/'`
git_user=`az keyvault secret show --vault-name deployment-user --name git-password |grep value|sed -e 's/.*\"\(.*\)\"/\1/'`
rails_master_key=`az keyvault secret show --vault-name deployment-user --name rails-master-key |grep value|sed -e 's/.*\"\(.*\)\"/\1/'`
export webapp_username='idfkmanjustwork'


export DB_USERNAME=$db_user
export DB_PASSWORD=$db_password
export DB_HOST=$db_host
export DB_DATABASE=$db_database
az webapp config appsettings set --name jobsrailsapp --resource-group jobsrailsapp --settings RAILS_MASTER_KEY="$rails_master_key" SECRET_KEY_BASE="$rails_master_key" RAILS_SERVE_STATIC_FILES="true" ASSETS_PRECOMPILE="true" |grep name

rake db:migrate RAILS_ENV=production
git remote remove azure
git remote add azure https://$webapp_username@jobsrailsapp.scm.azurewebsites.net/jobsrailsapp.git
git push azure main
