desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
#  if Time.now.hour % 6 == 0 # run every six hours
#    Hashtag.new.sync
#  end
end
