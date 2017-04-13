/*
	#001
	Query sales order values - list from largest to smallest / rank them
*/
select 
	orderid
	,orderdate
	,val
	,RANK() over(order by val desc) as ranking
from sales.OrderValues
order by ranking --orderdate