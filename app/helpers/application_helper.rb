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

def state_copleted_confition_for(order_state, element_state)
  order_state = Structs::Order::STATES[order_state]
  state_completed = 'state_completed'
  case element_state
  when 'waiting_state'
    return state_completed if order_state.positive?
  when 'assembling_state'
    return state_completed if order_state >= 3
  when 'delivering_state'
    return state_completed if order_state >= 5
  when 'finished_state'
    return state_completed if order_state == 6
  end

  ''
end
