require "digest"
class SubscribeToNewsletterService
  def initialize(user)
    @user = user
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @audience_id = ENV['MAILCHIMP_AUDIENCE_ID']
  end

  def call
    @gibbon.lists(@audience_id).members(Digest::MD5.hexdigest(@user.email.downcase)).upsert(
      body: {
        email_address: @user.email,
        status: "subscribed",
        merge_fields: {
          FNAME: @user.fname,
          LNAME: @user.lname
        }
      }
    )
  end

  def callcontact
    @gibbon.lists(@audience_id).members(Digest::MD5.hexdigest(@user.email.downcase)).upsert(
      body: {
        email_address: @user.email,
        status: "subscribed",
        merge_fields: {
          FNAME: @user.name,
          PHONE: @user.phone

        }
      }
    )
  end
end
