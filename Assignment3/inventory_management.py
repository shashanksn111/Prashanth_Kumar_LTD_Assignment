class Product:
    def __init__(self, product_id, name, stock_level, restock_threshold):
        self.product_id = product_id
        self.name = name
        self.stock_level = stock_level
        self.restock_threshold = restock_threshold  # Threshold to trigger restocking

    def __str__(self):
        return f"Product: {self.name}, Stock Level: {self.stock_level}, Restock Threshold: {self.restock_threshold}"


def process_orders(products, orders):
    """
    Processes incoming orders and updates product stock levels.
    Args:
    - products: A list of Product objects representing the current inventory.
    - orders: A list of tuples (product_id, quantity) representing the sales orders.

    Returns:
    - A list of products that need restocking.
    """
    restock_alerts = []  # List of products that need restocking
    
    for order in orders:
        product_id, order_quantity = order
        # Find the product based on the product_id
        product = next((p for p in products if p.product_id == product_id), None)
        
        if product is None:
            print(f"Error: Product with ID {product_id} does not exist.")
            continue
        
        # Check if there's enough stock to fulfill the order
        if product.stock_level >= order_quantity:
            product.stock_level -= order_quantity  # Reduce stock
            print(f"Order processed: {order_quantity} units of {product.name}.")
            
            # Check if the stock level falls below the restock threshold
            if product.stock_level < product.restock_threshold:
                print(f"Alert: {product.name} stock is below the threshold. Current stock: {product.stock_level}")
                restock_alerts.append(product)
        else:
            print(f"Error: Not enough stock for {product.name}. Current stock: {product.stock_level}")
    
    return restock_alerts


def restock_items(products, restock_list):
    """
    Restocks items based on the restock_list.
    Args:
    - products: A list of Product objects representing the current inventory.
    - restock_list: A list of tuples (product_id, quantity) representing the restocking.

    Returns:
    - None.
    """
    for restock in restock_list:
        product_id, restock_quantity = restock
        # Find the product based on the product_id
        product = next((p for p in products if p.product_id == product_id), None)
        
        if product is None:
            print(f"Error: Product with ID {product_id} does not exist for restocking.")
            continue
        
        # Update stock level
        product.stock_level += restock_quantity
        print(f"Restocked {restock_quantity} units of {product.name}. Current stock: {product.stock_level}")


if __name__ == "__main__":
    # Creating some products
    product1 = Product(1, "Laptop", 15, 10)
    product2 = Product(2, "Mouse", 50, 20)
    product3 = Product(3, "Keyboard", 8, 10)

    products = [product1, product2, product3]
    
    # Incoming orders (product_id, quantity)
    orders = [
        (1, 5),   # Ordering 5 Laptops
        (2, 10),  # Ordering 10 Mice
        (3, 5),   # Ordering 5 Keyboards (this should trigger an alert for restocking)
        (1, 20),  # Attempting to order more Laptops than available stock (error handling)
    ]
    
    # Process orders
    restock_alerts = process_orders(products, orders)

    # If any products need restocking, we simulate restocking them
    if restock_alerts:
        # Restock (product_id, quantity)
        restock_list = [(product.product_id, 20) for product in restock_alerts]  # Adding 20 units to all products needing restock
        restock_items(products, restock_list)

    # Final stock levels
    for product in products:
        print(product)
