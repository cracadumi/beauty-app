module ApplicationHelper
  def print_price(price_cents)
    number_to_currency price_cents / 100
  end
end
