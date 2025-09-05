class CleanupOldContactsJob < ApplicationJob
  queue_as :default

  def perform
    # Delete all contacts older than 1 week
    old_contacts = Contact.where('created_at < ?', 1.week.ago)
    count = old_contacts.count
    
    Rails.logger.info "🗑️  CLEANUP: Found #{count} contacts older than 1 week"
    
    old_contacts.destroy_all
    
    Rails.logger.info "🗑️  CLEANUP: Deleted #{count} old contacts"
  end
end