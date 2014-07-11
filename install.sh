sudo service apache2 stop
git pull origin master
RAILS_ENV=production bundle exec rake assets:precompile
sudo service apache2 start

echo "Hi, Daniele. Installation has completed, Please check site on browser now.  :) - xing"