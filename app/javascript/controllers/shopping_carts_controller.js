import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="shopping-carts"
export default class extends Controller {
  static values = { cost: Number }
  path = '/shopping_cart.json'

  initialize() {}

  add_item_to_shopping_card({params}) {
    const add_new_item = async (id) => {
      try {
        const response = await fetch(this.path, {
          method: 'PUT',
          body: JSON.stringify(
            {
              id: id,
              authenticity_token: this.auth_token()
            }
          ),
          headers: {
          'Content-Type': 'application/json'
          }
        });
        const response_data = await response.json();
        this.costValue = response_data['new_cost']
      } catch (error) {
        console.error('Ошибка:', error);
      }
    }

    add_new_item(params['id'])
  }

  costValueChanged() {
    document.querySelector('.shopping_cart__cost').textContent = this.costValue
  }

  auth_token() {
    const metas = document.getElementsByTagName('meta');

    for (let i = 0; i < metas.length; i++) {
      if (metas[i].getAttribute('name') === 'csrf-token' && metas[i].getAttribute('content') !== 'authenticity_token') {
        return metas[i].getAttribute('content');
      }
    }

    return ''
  }
}
