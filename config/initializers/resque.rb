require 'resque_scheduler'

Resque.redis = ENV["REDISTOGO_URL"]
Resque.redis.namespace = "resque:ElefeelyTwilioInterface"

Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))
