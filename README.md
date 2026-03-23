# 📊 Inventory Optimization & Demand Forecast Dashboard
### *End-to-End Supply Chain Analytics Project | SQL • Python (Prophet) • Power BI*

---

## 📂 Project Overview
[![Project Poster](Preview.png)](Preview.png)

**Project Title**: Olist E-Commerce Inventory Optimization
**Tools Used**: MySQL, Python (Jupyter Notebook), Power BI Desktop, FB Prophet

### 📝 Description
Ye project ek real-world business problem ko solve karta hai: **"Inventory Stock-outs aur Overstocking ko kaise roka jaye?"** Maine Olist E-commerce dataset ka use karke ek automated system banaya hai jo products ko prioritize karta hai (**ABC Analysis**), future demand predict karta hai (**AI Forecasting**), aur warehouse efficiency track karta hai (**Lead Time Analysis**).

---

## 🎯 Key Business Questions Answered
Dashboard ko aise design kiya gaya hai ki ye niche diye gaye sawalon ke jawab de sake:
* Hamare **Top 15% Products (Class A)** kaunse hain jo 70% revenue dete hain?
* Agle 30 dinon mein predicted demand kya hai aur hamara **Safety Stock** kahan hona chahiye?
* Kaunse categories mein **Stock-out Risk** sabse zyada hai?
* Kya hamara **Delivery Lead Time** (12.5 days) target ke mutabiq hai?
* Customer reviews aur sales volume ke beech kya correlation hai?

---

## 🚀 Tech Stack Details
* **MySQL**: Data cleaning, complex joins, aur window functions ke zariye **ABC Classification Views** banayi.
* **Python (Prophet)**: Time-series forecasting model train kiya taaki demand spikes aur seasonality (Holidays/Weekends) ko handle kiya ja sake.
* **Power BI**: Interactive visuals aur **Star Schema Data Modeling** ke zariye insights ko chamkaya.
* **DAX**: Custom measures banaye KPIs aur growth percentages calculate karne ke liye.

---

## 📈 Key Performance Indicators (KPIs)
Dashboard par ye main metrics highlight kiye gaye hain:
* **Total Revenue**: $10.8M+ (Historical Trend)
* **Avg. Delivery Time**: 12.5 Days (Logistics Benchmark)
* **Class A Contribution**: 70% of Total Sales
* **AI Forecast Accuracy**: High-confidence demand prediction intervals.

---

## 📊 Walkthrough of Key Visuals

### 🔹 1. AI Demand Forecast vs. Safety Threshold (Line Chart)
* **Insight**: Blue line (Predicted Demand) aur Red Dashed line (Safety Limit) ka comparison.
* **Actionable**: Jab Blue line Red ko touch karti hai, ye warehouse manager ke liye "Replenishment Alert" hai.

### 🔹 2. Inventory Distribution (Donut Chart)
* **Insight**: Products ka breakdown 'A', 'B', aur 'C' classes mein.
* **Actionable**: Class A products par 100% focus aur Class C par lean inventory management apply karna.

### 🔹 3. Avg. Delivery Lead Time (Gauge Chart)
* **Insight**: Order se delivery tak ka average waqt.
* **Actionable**: 12.5 din ka lead time dikhata hai ki logistics mein 25% improvement ka scope hai (Target: 10 Days).

### 🔹 4. Monthly Revenue Trend (Area Chart)
* **Insight**: Month-on-month sales ki "Volume" aur "Seasonality" track karta hai.
* **Actionable**: December peaks ke liye pehle se warehouse staff plan karne mein madad karta hai.

---

## 💡 Business Impact & Insights
1. **Focus on High-Value**: 15% SKUs hi 70% revenue drive karte hain, unka stock kabhi khatam nahi hona chahiye.
2. **Quality vs Sales**: Class A products par feedback count sabse zyada hai, jo brand trust maintain karne ke liye zaroori hai.
3. **Logistics Bottleneck**: Peak months mein delivery time badh jata hai, jise optimize karne ki zaroorat hai.

---

## 🏗️ Project Architecture
1. **Data Extraction**: MySQL se transactional data load kiya.
2. **Data Engineering**: SQL Views ke zariye ABC Logic aur Lead Time calculate kiya.
3. **AI Modeling**: Python mein Prophet model se 30-day forecast generate kiya.
4. **Visualization**: Power BI mein interactive slicers (Category/Class) ke saath report banayi.

---

## 👨‍🎓 Developed By
**[Rahul Solra]**
# Inventory_Replenishment_System
