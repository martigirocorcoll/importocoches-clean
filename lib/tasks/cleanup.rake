namespace :cleanup do
  desc "Delete contacts older than 1 week"
  task old_contacts: :environment do
    CleanupOldContactsJob.perform_now
  end
end