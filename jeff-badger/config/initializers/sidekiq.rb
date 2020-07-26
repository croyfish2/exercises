Sidekiq.configure_server do |config|
  if File.exist?('config/scheduled_jobs.yml')
    schedules=YAML.load(ERB.new(File.read('config/scheduled_jobs.yml')).result)
    Sidekiq::Cron::Job.load_from_array!(schedules[Rails.env])
  end
end
