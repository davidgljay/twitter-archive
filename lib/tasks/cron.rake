desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  if Time.now.hour % 6 == 0 # run every six hours
        @synclist = Hashtag.all.delete_if{|tag| tag.archive == false}
    secondaries = Array.new
    @synclist.each do |tag|
       tag.tweets.each do |tweet|
         secondaries << tweet.hashtags
       end
    end
    @synclist << secondaries
    @synclist.flatten!.uniq!.each do |tag|
       tag.delay.get_tweets
    end
  end
end
