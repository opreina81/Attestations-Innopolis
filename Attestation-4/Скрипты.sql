
-- 1. информация о всех контрактах, связанных с сотрудниками департамента «Logistic». Вывести: contract_id, employee_name

--можно так:

SELECT co.id AS contract_id, e.name AS employee_name FROM employees e 
	JOIN department d ON d.id = e.department_id
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
WHERE d.name = 'Logistic'
	
--или так, в данном случае оба запроса равнозначны, но в этом мы учитываем не только название отдела, но и его уникальный идентификатор:	
SELECT co.id AS contract_id, e.name AS employee_name FROM employees e 
	JOIN department d ON d.id = e.department_id
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
WHERE d.id = (SELECT id FROM department WHERE name = 'Logistic')


	
-- 2. Найти среднюю стоимость контрактов, заключенных сотрудником Ivan Ivanov. Вывести: среднее значение amount

SELECT ROUND(AVG(co.amount),0) AS average_cost_of_contracts FROM employees e 
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
GROUP BY e.name 
HAVING e.name='Ivan Ivanov'

-- в задании не сказано, что надо вывести фамилию и имя сотрудника, но с ФИ вывод информации был бы нагляднее, поэтому в допфайле приложен соотвествующий скрипт  


-- 3. Найти самую часто встречающуюся локации среди всех заказчиков. Вывести: location, count /*почему использовала именно этот скрипт, а не более короткий можно посмотреть во допфайле с пояснениями*/

SELECT  location, count(location) FROM customer 
GROUP BY location
HAVING count(location) = (SELECT count(location) FROM customer
GROUP BY location
ORDER BY count(location)
DESC
LIMIT 1)


-- 4. Найти контракты одинаковой стоимости. Вывести count, amount

SELECT  count(amount), amount FROM contract 
GROUP BY amount
having count(amount)>1



-- 5. Найти заказчика с наименьшей средней стоимостью контрактов. Вывести customer_name, среднее значение amount
-- если заказчиков с  наименьшей средней стоимостью контрактов окажется более одного (стоимость будет равна у нескольких заказчиков) более предпочтительный для использования, более верный будет этот скрипт:

SELECT cu.customer_name, ROUND(AVG(co.amount),0) AS average_cost_of_contracts FROM employees e 
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
	JOIN customer cu ON cu.id = co.customer_id
GROUP BY cu.customer_name
HAVING AVG(co.amount)=(SELECT AVG(co.amount) FROM employees e 
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
	JOIN customer cu ON cu.id = co.customer_id
GROUP BY cu.customer_name
ORDER BY AVG(co.amount)
ASC 
LIMIT 1)

-- если уверены, что наименьшая средняя стоимость контрактов только у одного заказчика, то этот:

SELECT cu.customer_name, ROUND(AVG(co.amount),0) AS average_cost_of_contracts FROM employees e 
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
	JOIN customer cu ON cu.id = co.customer_id
GROUP BY cu.customer_name
ORDER BY AVG(co.amount)
ASC 
LIMIT 1




-- 6. Найти отдел, заключивший контрактов на наибольшую сумму. Вывести: department_name, sum
-- предложенный вариант учитывает вероятность, что выведутся все отделы, если их наибольшие суммы контрактов будут равны

SELECT d.name AS department, sum(co.amount) AS sum_contract_amount FROM employees e 
	JOIN department d ON d.id = e.department_id
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
	GROUP BY d.name
	HAVING sum(co.amount)= (SELECT sum(co.amount) FROM employees e 
	JOIN department d ON d.id = e.department_id
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
	GROUP BY d.name
	ORDER BY sum(co.amount)
	DESC 
	LIMIT 1)
	
