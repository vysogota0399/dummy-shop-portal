module ApplicationHelper
  include Pagy::Frontend
end

def order_content_info_for(order)
  case order.state
  when 'ready'
    "Время доставки"
  else
    "Заказ оформлен #{order.created_at.strftime('%d %b %Y в %H:%M')}"
  end
end
