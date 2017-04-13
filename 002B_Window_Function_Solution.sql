/*
	Same example problem
	- view order values
		- their percent of the orders customer
		- the amount it varies from the average of current customer

		- the percent against grand total
		- the amount it varies from the grand average
*/

select orderid, custid, val
	--customer details
	,percentage_of_customer = 
		CAST(
			100. * val / sum(val) over (partition by custid)
			AS NUMERIC(5, 2)
		)
	,difference_from_customer_avg = 
		val - avg(val) over (partition by custid)

	----against grand total/average
	--,percentage_of_grand_total =
	--	CAST(
	--		100. * val / sum(val) over()
	--		as NUMERIC(5,2)
	--	)
	--,difference_from_grand_avg =
	--	val - avg(val) over ()
from sales.ordervalues