
# 1: Importing Libraries

import pandas as pd
import numpy as np
from prophet import Prophet

# 2: Load Data

orders = pd.read_csv("olist_orders_dataset.csv")
items = pd.read_csv("olist_order_items_dataset.csv")
products = pd.read_csv("olist_products_dataset.csv")
customers = pd.read_csv("olist_customers_dataset.csv")

print("Data Loaded Successfully")


# 3: Merge Data (SQL JOIN)

df = orders.merge(items, on='order_id')
df = df.merge(products, on='product_id')
df = df.merge(customers, on='customer_id')
print(df.info())
print(df.describe())
print("Data Merged Successfully")

# 4: Data Cleaning

df['order_purchase_timestamp'] = pd.to_datetime(df['order_purchase_timestamp'])

# important columns only
df = df[['order_id', 'product_id', 'order_purchase_timestamp']]

df = df.dropna()

print("Data Cleaned")


#  5: Create Demand

df['date'] = df['order_purchase_timestamp'].dt.date

demand = df.groupby(['product_id', 'date']).size().reset_index(name='demand')

print("Demand Created")


# 6: Forecasting (FIXED VERSION)


# select product with max data
product_counts = demand['product_id'].value_counts()
product_id = product_counts.idxmax()

product_data = demand[demand['product_id'] == product_id]

# rename for Prophet
product_data = product_data.rename(columns={'date': 'ds', 'demand': 'y'})
product_data['ds'] = pd.to_datetime(product_data['ds'])

print("Selected Product:", product_id)
print("Total Rows:", len(product_data))

# apply Prophet
model = Prophet()
model.fit(product_data)

future = model.make_future_dataframe(periods=30)
forecast = model.predict(future)

print("Forecast Completed")


# 7: Inventory Calculations

avg_demand = product_data['y'].mean()
std_demand = product_data['y'].std()

lead_time = 7
Z = 1.65  # 95% service level

safety_stock = Z * std_demand * np.sqrt(lead_time)
reorder_point = avg_demand * lead_time + safety_stock

print("Safety Stock:", round(safety_stock, 2))
print("Reorder Point:", round(reorder_point, 2))


# 8: Reorder Alert

current_stock = 50

if current_stock < reorder_point:
    print("Reorder Required")
else:
    print("Stock is sufficient")

# 9: Save Output

forecast.to_csv("forecast_output.csv", index=False)
demand.to_csv("demand_data.csv", index=False)

print("Files Saved: forecast_output.csv & demand_data.csv")

# End of the Projects