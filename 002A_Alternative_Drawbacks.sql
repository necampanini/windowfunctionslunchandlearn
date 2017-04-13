/*
	#002A - Example of Alternative Drawnback
		
	Given OrderValues view, what if you needed to:
	- calculate for each order
		- the percentage of the current order value of the customer total
		- as wlel as the difference from the customer average

	current order value is a detail
	customer total/average are aggregates

	if group data by customer - don't have access to the individual 
	order values

	one way to group data by customer, define CTE and join 
	to match detail with aggregates
*/

;WITH aggregates_cte AS (
	SELECT custid, SUM(val) as sum_val, AVG(val) as avg_val
	FROM sales.OrderValues
	group by custid
)
, grand_aggregate_cte AS (
	select sum(val) as sumval, avg(val) as avgVal
	from Sales.OrderValues
)

select
	O.orderid
	,o.custid
	,o.val
	,CAST(100. * O.val / a.sum_val AS numeric(5, 2)) as percent_of_customer
	,O.val - a.avg_val AS difference_from_customer_average

	----grand aggregate numbers
	--,CAST(100. * O.val / GA.sumval AS Numeric(5, 2)) as percent_of_all
	--,O.val - GA.avgVal as difference_from_all
from Sales.OrderValues as o

inner join aggregates_cte as A
	on O.custid = A.custid

--cross join grand_aggregate_cte as GA



/*
	what if you needed to invovle the percentage from the grand total
	and the difference from the grand average.

	again, we can write another CTE and join

	, grand_aggregate_cte AS (
		select sum(val) as sumval, avg(val) as avgVal
		from Sales.OrderValues
	)
*/



/*
	sub query solution
*/

-- subqueries, detail and cust aggregates
SELECT orderid, custid, val,
  CAST(100. * val /
        (SELECT SUM(O2.val)
         FROM Sales.OrderValues AS O2
         WHERE O2.custid = O1.custid) AS NUMERIC(5, 2)) AS pctcust,
  val - (SELECT AVG(O2.val)
         FROM Sales.OrderValues AS O2
         WHERE O2.custid = O1.custid) AS diffcust
FROM Sales.OrderValues AS O1;

-- subqueries, detail, cust and grand aggregates
SELECT orderid, custid, val,
  CAST(100. * val /
        (SELECT SUM(O2.val)
         FROM Sales.OrderValues AS O2
         WHERE O2.custid = O1.custid) AS NUMERIC(5, 2)) AS pctcust,
  val - (SELECT AVG(O2.val)
         FROM Sales.OrderValues AS O2
         WHERE O2.custid = O1.custid) AS diffcust,
  CAST(100. * val /
        (SELECT SUM(O2.val)
         FROM Sales.OrderValues AS O2) AS NUMERIC(5, 2)) AS pctall,
  val - (SELECT AVG(O2.val)
         FROM Sales.OrderValues AS O2) AS diffall
FROM Sales.OrderValues AS O1;

--terrible

--revisit same set of data each sub query