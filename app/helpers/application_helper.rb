module ApplicationHelper
  def money_with_cents_and_with_symbol(amount)
    humanized_money_with_symbol(amount, {no_cents: false, no_cents_if_whole: false})
  end

  def percentage_with_symbol(val)
    "%.1f%" % val
  end
end
