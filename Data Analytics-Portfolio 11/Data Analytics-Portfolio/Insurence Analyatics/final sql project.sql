create database insurence;
use insurence;
select * from brokerage;
select* from fees;
select * from individual_budgets;
select * from invoice;
select* from meeting;
select* from opportunity;




# Branch Dashboard KPIs #


#2) Account execute by Invoice 
select `Account Executive`,count(invoice_number) as `account_exe_by_invoice`from invoice
group by `Account Executive`order by`account_exe_by_invoice`desc;

## 3) No of Meeting by Account executive
select `Account Executive`,count(meeting_date) as `meet_by_account_exe`from meeting
group by `Account Executive`;

## 4) Top  opportunities
select count(opportunity_id)as Total_opportunity from opportunity;

select  stage,count(opportunity_id) as Total_opportunity from opportunity
group by Stage
 order by Total_opportunity desc; 




    
    
    
    
    
    
  #Kpi 3 Cross Sell, New , Renewal for Target, Invoice , Achieved , Placed Achievement%, Invoice Achievement%  
    
    
    
    USE insurence;

WITH Revenue AS (
    -- Combine all revenue sources
    SELECT `Account Exe ID`, Amount, income_class FROM brokerage
    UNION ALL
    SELECT `Account Exe ID`, Amount, income_class FROM fees
    UNION ALL
    SELECT `Account Exe ID`, Amount, income_class FROM invoice
),

Targets AS (
    SELECT 
        'Cross Sell' AS income_class, SUM(`Cross Sell Bugdet`) AS Target FROM `individual_budgets`
    UNION ALL
    SELECT 
        'New', SUM(`New Budget`) FROM `individual_budgets`
    UNION ALL
    SELECT 
        'Renewal', SUM(`Renewal Budget`) FROM `individual_budgets`
),

InvoiceData AS (
    SELECT 
        income_class,
        SUM(Amount) AS Invoice
    FROM invoice
    GROUP BY income_class
),

AchievedData AS (
    SELECT 
        income_class,
        SUM(Amount) AS Achieved
    FROM (
        SELECT Amount, income_class FROM brokerage
        UNION ALL
        SELECT Amount, income_class FROM fees
    ) t
    GROUP BY income_class
)

SELECT 
    t.income_class,

    -- 🎯 Target (Millions)
    CONCAT(ROUND(t.Target/1000000,2),'M') AS Target,

    -- 💰 Invoice (Millions)
    CONCAT(ROUND(COALESCE(i.Invoice,0)/1000000,2),'M') AS Invoice,

    -- 💰 Achieved (Millions)
    CONCAT(ROUND(COALESCE(a.Achieved,0)/1000000,2),'M') AS Achieved,

    -- 📊 Placed Achievement %
    CONCAT(
        ROUND(
            COALESCE(a.Achieved,0) / NULLIF(t.Target,0) * 100,
        2),'%'
    ) AS Placed_Achievement_Percentage,

    -- 📊 Invoice Achievement %
    CONCAT(
        ROUND(
            COALESCE(i.Invoice,0) / NULLIF(t.Target,0) * 100,
        2),'%'
    ) AS Invoice_Achievement_Percentage

FROM Targets t

LEFT JOIN InvoiceData i 
    ON t.income_class = i.income_class

LEFT JOIN AchievedData a 
    ON t.income_class = a.income_class

ORDER BY 
    FIELD(t.income_class, 'Cross Sell', 'New', 'Renewal');
    
    
    
    #KPI 1 – Number of Invoice by Account Executive
    USE insurece;

SELECT 
    `Account Executive`,

    SUM(CASE WHEN income_class = 'Cross Sell' THEN 1 ELSE 0 END) AS Cross_Sell_count,
    SUM(CASE WHEN income_class = 'New' THEN 1 ELSE 0 END) AS New_count,
    SUM(CASE WHEN income_class = 'Renewal' THEN 1 ELSE 0 END) AS Renewal_count,
    SUM(CASE WHEN income_class IS NULL THEN 1 ELSE 0 END) AS NULL_invoice_count,

    COUNT(invoice_number) AS Invoice_count

FROM invoice
GROUP BY `Account Executive`
ORDER BY Invoice_count DESC;
    
    
    
    #KPI 2 – Yearly Meeting Count
   
SELECT 
    YEAR(STR_TO_DATE(meeting_date, '%d-%m-%Y')) AS Meeting_Year,
    COUNT(*) AS Meeting_count
FROM meeting
GROUP BY YEAR(STR_TO_DATE(meeting_date, '%d-%m-%Y'));


# KPI 4 – Stage Funnel by Revenue
SELECT 
    stage,
    SUM(revenue_amount) AS Revenue_amt
FROM opportunity
GROUP BY stage
ORDER BY Revenue_amt DESC;


#KPI 5 – Number of Meetings by Account Executive
SELECT 
    `Account Executive`,
    COUNT(*) AS Meeting_count
FROM meeting
GROUP BY `Account Executive`
ORDER BY Meeting_count DESC;


# KPI 6 – Top 5 Opportunity by Revenue
SELECT 
    opportunity_name,
    SUM(revenue_amount) AS Revenue_amt
FROM opportunity
GROUP BY opportunity_name
ORDER BY Revenue_amt DESC
LIMIT 5;


# KPI 7 – Opportunity Product Distribution
SELECT 
    product_group,

    COUNT(`Account Executive`) AS oppty_count,

    CONCAT(
        ROUND(
            COUNT(`Account Executive`) * 100.0 / 
            SUM(COUNT(`Account Executive`)) OVER (),
        2),
        '%'
    ) AS Total_percent

FROM opportunity
GROUP BY product_group
ORDER BY oppty_count DESC;



    
   