class Plan
  DURATION = 12 # months

  PLANS = {
    free: OpenStruct.new({
      active: false,
      upgrade_rating: 0,
      name: 'FREE',
      price_cents: 0,
      post_limit: 5,
      post_category: false,
      blog_logo: false
    }),
    pro: OpenStruct.new({
      active: true,        # Can be purchased
      upgrade_rating: 10,
      name: 'PRO',
      price_cents: 700,
      post_limit: nil,     # Can post unlimited videos
      post_category: true, # Can put videos in the category "My successes"
      blog_logo: true      # Can upload a custom logo
    }),
    expert: OpenStruct.new({
      active: true,
      upgrade_rating: 100,
      name: 'EXPERT',
      price_cents: 1000,
      post_limit: nil,     # Can post unlimited videos
      post_category: true, # Can put videos in the category "My successes"
      blog_logo: true      # Can upload a custom logo
    })
  }.with_indifferent_access.freeze

  def self.by_plan_type(plan_type)
    PLANS[plan_type]
  end

  def self.free_plan
    by_plan_type(:free)
  end

  def self.pro_plan
    by_plan_type(:pro)
  end

  def self.expert_plan
    by_plan_type(:expert)
  end

end
