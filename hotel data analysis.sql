-- List the guests who have bookings from 25-June to 1 -July.
SELECT DISTINCT 
    B.guest_id,
    CONCAT(G.first_name, ' ', G.last_name) AS Guest_Name
FROM 
    Guests G
INNER JOIN 
    Bookings B ON  B.guest_id
WHERE 
    B.check_in_date BETWEEN '2024-05-25' AND '2024-06-01';




-- Find the total revenue generated from all bookings.
SELECT
    SUM(
        CASE 
            WHEN DATEDIFF(check_out_date, check_in_date) = 0 THEN 1
            ELSE DATEDIFF(check_out_date, check_in_date)
        END * amount
    ) AS total_revenue
FROM
    Bookings;

    
    
-- Find the average stay duration of guests.
WITH Stay AS (
    SELECT
        CASE
            WHEN DATEDIFF(check_out_date, check_in_date) = 0 THEN 1
            ELSE DATEDIFF(check_out_date, check_in_date)
        END AS stay_duration
    FROM
        Bookings
)
SELECT
    FORMAT(AVG(stay_duration), 2) AS average_stay_duration
FROM
    Stay;

    
    
    
-- Find the guest who booked/Get the same room multiple times.

SELECT
    CONCAT(g.first_name, ' ', g.last_name) AS full_name,
    b.guest_id,
    b.room_number,
    COUNT(*) AS booking_count
FROM 
    Bookings b
INNER JOIN 
    Guests g ON b.guest_id 
GROUP BY
    g.first_name, g.last_name, b.guest_id, b.room_number
HAVING 
    COUNT(*) > 1;



-- List the top 2 guests by total amount spent.
SELECT 
    b.guest_id,
    CONCAT(G.first_name, ' ', G.last_name) AS full_name,
    SUM(CASE
            WHEN DATEDIFF(check_out_date, check_in_date) = 0 THEN 1
            ELSE DATEDIFF(check_out_date, check_in_date)
        END * b.Amount) AS total_amount_spent
FROM 
    Guests G
INNER JOIN 
    Bookings b ON b.guest_id
GROUP BY 
	b.guest_id,G.first_name, G.last_name
ORDER BY 
    total_amount_spent DESC
LIMIT 2;


-- Find the average total amount spent by guests who stayed more than 3 days.

WITH LongStays AS (
    SELECT
        guest_id,
        CASE
            WHEN DATEDIFF(check_out_date, check_in_date) = 0 THEN 1
            ELSE DATEDIFF(check_out_date, check_in_date)
        END AS stay_duration,
        amount
    FROM 
        Bookings
)
SELECT
    AVG(stay_duration * amount) AS total_amount_spent
FROM 
    LongStays
WHERE 
    stay_duration > 3;

    
    
-- List all guests along with their total stay duration and amount across all bookings

WITH LongStays AS
(
   SELECT
   a.guest_id,
   CONCAT(first_name, ' ', last_name) AS full_name,
   CASE
   WHEN DATEDIFF(day, check_in_date, check_out_date) = 0 THEN 1
   ELSE DATEDIFF(day, check_in_date, check_out_date)
   END AS stay_duration,
   amount
   FROM Bookings a
   INNER JOIN Guests b on a.guest_id = b.guest_id
)
    SELECT
    guest_id,
    full_name,
    Sum(stay_duration) AS TotalStayDays,
    Sum((stay_duration* Amount)) AS total_amount_spent
    FROM LongStays
	group by guest_id, full_name
	order by guest_id
-- find the city from where the most guests have stayed



SELECT 
    G.city,
    COUNT(b.guest_id) AS guest_count
FROM 
    Guests G
INNER JOIN 
    Bookings B ON  B.guest_id
GROUP BY 
    G.city
ORDER BY 
    guest_count DESC
LIMIT 1;


