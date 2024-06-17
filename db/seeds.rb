# frozen_string_literal: true

menu_items = [
  # Appetizers
  { name: "Garlic Parmesan Truffle Fries", price: 9.99, description: "Hand-cut fries tossed in truffle oil, garlic, and parmesan.", availability: true },
  { name: "Crispy Calamari with Spicy Aioli", price: 12.99, description: "Lightly battered calamari rings served with a zesty aioli.", availability: true },
  { name: "Artisan Cheese & Charcuterie Board", price: 18.99, description: "Assortment of cured meats, artisanal cheeses, and accompaniments.", availability: true },

  # Main Courses
  { name: "Wood-Fired Margherita Pizza", price: 14.99, description: "Thin-crust pizza with San Marzano tomatoes, fresh mozzarella, and basil.", availability: true },
  { name: "Homemade Fettuccine Alfredo with Chicken", price: 18.99, description: "Creamy Alfredo sauce tossed with fettuccine pasta and grilled chicken.", availability: true },
  { name: "Pan-Seared Atlantic Salmon", price: 22.99, description: "Salmon fillet with a lemon-herb crust, served with seasonal vegetables.", availability: true },
  { name: "Steak Frites", price: 29.99, description: "Grilled New York strip steak served with hand-cut fries and béarnaise sauce.", availability: true },
  { name: "Vegan Lentil Curry", price: 16.99, description: "Flavorful lentil curry with coconut milk, vegetables, and aromatic spices.", availability: true },

  # Sides
  { name: "Roasted Brussels Sprouts with Balsamic Glaze", price: 6.99, description: "Tender Brussels sprouts roasted with balsamic vinegar and garlic.", availability: true },
  { name: "Garlic Parmesan Roasted Broccoli", price: 5.99, description: "Fresh broccoli florets roasted with garlic, parmesan, and lemon zest.", availability: true },
  { name: "Creamy Parmesan Risotto", price: 8.99, description: "Arborio rice cooked in a creamy parmesan broth with white wine and herbs.", availability: true },

  # Desserts
  { name: "Deconstructed Tiramisu", price: 9.99, description: "Modern take on classic tiramisu with coffee-soaked ladyfingers, mascarpone mousse, and cocoa nibs.", availability: true },
  { name: "Warm Chocolate Lava Cake", price: 10.99, description: "Decadent chocolate cake with a molten center, served with vanilla bean ice cream.", availability: true },
  { name: "Assorted Gelato & Sorbet", price: 6.99, description: "Selection of house-made gelato and sorbet flavors.", availability: true },

  # Drinks
  { name: "House-Made Iced Tea", price: 3.50, description: "Refreshing iced tea brewed with a blend of black and herbal teas.", availability: true },
  { name: "Sparkling Lemonade", price: 4.50, description: "Sparkling water with fresh lemon juice and a touch of sweetness.", availability: true },
  { name: "Cabernet Sauvignon (Glass)", price: 8.00, description: "Full-bodied red wine with notes of blackcurrant and vanilla.", availability: true },
  { name: "Pinot Grigio (Bottle)", price: 25.00, description: "Crisp white wine with aromas of citrus and pear.", availability: true },
]

menu_items.each do |item_attributes|
  begin
    MenuItem.create!(item_attributes)
  rescue ActiveRecord::RecordInvalid => e
    puts "Error creating menu item: #{e.message}" # Output error message for debugging
  end
end
