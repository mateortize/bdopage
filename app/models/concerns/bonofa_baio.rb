module Account::BonofaBaio
  extend ActiveSupport::Concern
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def find_with_bonofa_oauth(oauth)
      account = Account.find_by_email(oauth.info.email)

      if account
        account.promotion_code = oauth.info.promotion_code
      else
        password = Devise.friendly_token[0,20]
        account = Account.new(
          email:                  oauth.info.email,
          first_name:             oauth.info.first_name,
          last_name:              oauth.info.last_name,
          promotion_code:         oauth.info.promotion_code,
          language:               oauth.info.language,
          info:                   oauth.info,
          password:               password,
          password_confirmation:  password,
        )
      end
      
      #account.remote_avatar_image_url = oauth.info.profile_image_url
      account.save
      
      if oauth.info.baio_package.blank? or ["no_package", "smart_package"].include?(oauth.info.baio_package)
        if account.has_active_subscription? and account.active_subscription.method == 'baio'
          account.active_subscription.cancel!
        end
        account.plan_id = Plan.free.id
      else
        plan = Plan.pro

        unless account.has_active_subscription?
          account.subscriptions.create(
            plan_id:    plan.id,
            method:     'baio',
            expired_at: Time.now + 100.year,
            status:     1
          )
        end

        account.plan_id = plan.id
      end

      account.save
      account
    end
  end
end