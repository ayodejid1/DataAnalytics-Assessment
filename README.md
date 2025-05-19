# DataAnalytics-Assessment

## Overview
Four standalone SQL files; each contains one query answering its respective question.

---

## Question 1 – Customer Lifetime Value
**Approach**  
1. CTE `tenure`: total months since signup (`YEAR*12 + MONTH`).  
2. CTE `tx`: inflow transactions (`confirmed_amount > 0`) and kobo→naira conversion.  
3. Join, annualise transaction rate, apply 0.1 % profit to compute **estimated_clv**.  

**Challenges**  
- Ensuring tenure used **total** months, not just month component.  
- Avoiding divide-by-zero when customers lack transactions (used `GREATEST` and `NULLIF`).  

---

## Question 2 – …
