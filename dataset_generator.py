import pandas as pd
import numpy as np
from faker import Faker
import random

# Initialize Faker
faker = Faker()

# Set random seed for reproducibility
random.seed(42)
np.random.seed(42)

# Define dataset sizes
num_customers = 200
num_products = 50
num_stores = 10
num_sales = 1000

# Define categories and relevant product names
category_to_products = {
    "Electronics": ["Smartphone", "Laptop", "Tablet", "Smartwatch", "Headphones", "Bluetooth Speaker", "Camera"],
    "Clothing": ["T-Shirt", "Jeans", "Jacket", "Dress", "Sweater", "Hat", "Shoes"],
    "Groceries": ["Rice", "Bread", "Milk", "Cheese", "Vegetables", "Fruits", "Eggs"],
    "Toys": ["Action Figure", "Board Game", "Puzzle", "Doll", "Toy Car", "Building Blocks"],
    "Books": ["Fiction Novel", "Non-Fiction Book", "Children's Book", "Cookbook", "Mystery Novel", "Fantasy Novel"]
}

# Generate Customers dataset
customers = pd.DataFrame({
    "CustomerID": range(1, num_customers + 1),
    "Name": [faker.name() for _ in range(num_customers)],
    "Gender": [random.choice(["Male", "Female", "Other"]) for _ in range(num_customers)],
    "Age": [random.randint(18, 65) for _ in range(num_customers)],
    "City": [faker.city() for _ in range(num_customers)],
    "MembershipType": [random.choice(["Basic", "Premium", "Gold"]) for _ in range(num_customers)]
})

# Generate Products dataset
categories = [random.choice(list(category_to_products.keys())) for _ in range(num_products)]

products = pd.DataFrame({
    "ProductID": range(1, num_products + 1),
    "ProductName": [random.choice(category_to_products[category]) for category in categories],
    "Category": categories,
    "Price": [round(random.uniform(5, 500), 2) for _ in range(num_products)],
    "CostPrice": [round(random.uniform(2, 300), 2) for _ in range(num_products)],
    "StockQuantity": [random.randint(0, 100) for _ in range(num_products)]
})

# Generate Stores dataset
stores = pd.DataFrame({
    "StoreID": range(1, num_stores + 1),
    "StoreName": [faker.company() for _ in range(num_stores)],
    "City": [faker.city() for _ in range(num_stores)]
})

# Generate Sales dataset
sales = pd.DataFrame({
    "SaleID": range(1, num_sales + 1),
    "CustomerID": [random.randint(1, num_customers) for _ in range(num_sales)],
    "ProductID": [random.randint(1, num_products) for _ in range(num_sales)],
    "StoreID": [random.randint(1, num_stores) for _ in range(num_sales)],
    "QuantitySold": [random.randint(1, 10) for _ in range(num_sales)],
    "SaleDate": [faker.date_between(start_date='-2y', end_date='today') for _ in range(num_sales)]
})

# Save datasets to CSV files
customers.to_csv("./dataset/Customers.csv", index=False)
products.to_csv("./dataset/Products.csv", index=False)
stores.to_csv("./dataset/Stores.csv", index=False)
sales.to_csv("./dataset/Sales.csv", index=False)

print("Synthetic datasets with relevant product names generated and saved as CSV files.")
