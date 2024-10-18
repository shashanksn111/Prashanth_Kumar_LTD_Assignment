class Product:
    def __init__(self, product_id, name, description, price):
        self.product_id = product_id
        self.name = name
        self.description = description
        self.price = price

    def __str__(self):
        return f"{self.name} (${self.price})"
    
class User:
    def __init__(self, user_id, name, email, address):
        self.user_id = user_id
        self.name = name
        self.email = email
        self.address = address
        self.orders = []  # A user can have multiple orders

    def create_order(self, products):
        order = Order(self, products)
        self.orders.append(order)
        return order

    def view_orders(self):
        for order in self.orders:
            print(order)

class Order:
    def __init__(self, user, products):
        self.order_id = self.generate_order_id()
        self.user = user
        self.products = products  # List of Product objects
        self.status = 'pending'  # default status
        self.payment = None

    def generate_order_id(self):
        import random
        return f'ORD{random.randint(1000, 9999)}'

    def calculate_total(self):
        return sum(product.price for product in self.products)

    def make_payment(self):
        amount = self.calculate_total()
        self.payment = Payment(self, amount)
        self.status = 'completed'

    def change_status(self, new_status):
        self.status = new_status

    def __str__(self):
        product_list = ", ".join([product.name for product in self.products])
        return f"Order ID: {self.order_id}, Products: [{product_list}], Status: {self.status}, Total: ${self.calculate_total()}"
    
class Payment:
    def __init__(self, order, amount):
        self.payment_id = self.generate_payment_id()
        self.order = order
        self.amount = amount
        self.status = 'pending'  # default status
        self.payment_date = None

    def generate_payment_id(self):
        import random
        return f'PAY{random.randint(1000, 9999)}'

    def process_payment(self):
        self.status = 'completed'
        from datetime import datetime
        self.payment_date = datetime.now()

    def __str__(self):
        return f"Payment ID: {self.payment_id}, Amount: ${self.amount}, Status: {self.status}, Date: {self.payment_date}"
    
if __name__ == "__main__":
    # Creating some products
    product1 = Product(1, "Laptop", "Gaming Laptop", 1200)
    product2 = Product(2, "Mouse", "Wireless Mouse", 50)

    # Creating a user
    user = User(1, "John Doe", "john@example.com", "123 Street, City")

    # Creating an order with products
    order = user.create_order([product1, product2])

    # Viewing user's orders
    user.view_orders()

    # Processing payment
    order.make_payment()
    order.payment.process_payment()

    # Print the details
    print(order)
    print(order.payment)
