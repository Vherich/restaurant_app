# Create a table
table = Table.create(number: 1)

# Create some menu items
menu_items = [
  MenuItem.create(name: "Burger", price: 12.99, description: "Delicious beef burger with all the fixings", availability: true),
  MenuItem.create(name: "Fries", price: 4.50, description: "Crispy golden fries", availability: true),
  MenuItem.create(name: "Soda", price: 2.00, description: "Refreshing soda drink", availability: true)
]

# Create a new order
order = Order.create(status: 'pending', table_id: table.id)

# Create order items for the order
order.order_items.create(menu_item: menu_items[0], quantity: 2)
order.order_items.create(menu_item: menu_items[1], quantity: 1)
order.order_items.create(menu_item: menu_items[2], quantity: 2)

# Calculate and update the order total
order.update(total: order.order_items.sum { |item| item.menu_item.price * item.quantity })
