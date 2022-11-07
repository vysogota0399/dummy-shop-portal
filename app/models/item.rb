class Item < ApplicationRecord
  enum :kind, [:alcohol, :vegetables, :fruit, :nuts, :sweets, :milk, :cheese, :eggs,
               :herbal_products, :meat, :fowl, :sausage, :delicacies, :fish, :seafood, :caviar]

  def cost_rub
    cost_cops.to_f/100.round(2)
  end

  def image_path
    "#{kind}.jpeg"
  end
end
