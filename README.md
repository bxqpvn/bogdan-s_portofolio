# Revenue Metrics Dashboard (SQL + Tableau)

### [Tableau Dashboard](https://public.tableau.com/views/ProiectRevenueMetrics_17285775370570/RevenueMetrics?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
My role was to represent the financial flow analysis by creating a dashboard that allows us to track and analyze the financial data, including revenue, expenses and profit, aiming to help project managers develop strategies at increasing revenue and optimizing business processes.
- Utilized the SQL (DBeaver) to query the data base, making several grouped and ordered subqueries, aggregation functions, joins between CTEs, to calculate some revenue metrics.
- Exported the result as a csv file and imported it into Tableau to create visualizations that include calculated fields such as MRR, ARPPU, Churn Rate and Customer Lifetime Value.
- Final dashboard contains 6 charts, including MRR Expansion VS Contraction or Month over month Churn Rate. I added some filters to create a little interactivity.


From analyzing the charts, we can draw the following conclusions:

1. The Churn Rate is very high in certain months, such as April (69.8%), indicating an issue with customer retention.
2. MRR (Monthly Recurring Revenue) and user count grow together, but user growth may slow in some months.
3. Customer Lifetime Value (CLV) decreases as user numbers increase, suggesting new users may be less valuable.
4. The MRR Expansion vs Contraction shows overall revenue growth but significant losses in one month ($919).
5. Comparisons between games reveal large variations in customer value and lifetime. Game 3 has a much higher CLV than others.
This indicates a need for strategic interventions to improve both retention and customer value.

The final conclusion would be that we need to focus on reducing the churn rate, especially in months with high values. This can be achieved by improving the user experience and offering loyalty incentives.
Additionally, we should investigate why CLV decreases while the number of users increases, possibly by analyzing the quality of new customers and the offers they receive. Optimizing games with lower CLV could lead to overall revenue growth.
