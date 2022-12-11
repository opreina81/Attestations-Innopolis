
-- 1. ���������� � ���� ����������, ��������� � ������������ ������������ �Logistic�. �������: contract_id, employee_name

--����� ���:
SELECT co.id AS contract_id, e.name AS employee_name FROM employees e 
	JOIN department d ON d.id = e.department_id
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
WHERE d.name = 'Logistic'
	
--��� ���, � ������ ������ ��� ������� �����������, �� � ���� �� ��������� �� ������ �������� ������, �� � ��� ���������� �������������:	
SELECT co.id AS contract_id, e.name AS employee_name FROM employees e 
	JOIN department d ON d.id = e.department_id
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
WHERE d.id = (SELECT id FROM department WHERE name = 'Logistic')


	
-- 2. ����� ������� ��������� ����������, ����������� ����������� Ivan Ivanov. �������: ������� �������� amount

SELECT ROUND(AVG(co.amount),0) AS average_cost_of_contracts FROM employees e 
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
GROUP BY e.name 
HAVING e.name='Ivan Ivanov'

-- � ������� �� �������, ��� ���� ������� ������� � ��� ����������, �� � �� ����� ���������� ��� �� ���������, ������� � �������� �������� �������������� ������  



-- 3. ����� ����� ����� ������������� ������� ����� ���� ����������. �������: location, count /*������ ������������ ������ ���� ������, � �� ����� �������� ����� ���������� �� �������� � �����������*/

SELECT  location, count(location) FROM customer 
GROUP BY location
HAVING count(location) = (SELECT count(location) FROM customer
GROUP BY location
ORDER BY count(location)
DESC
LIMIT 1)


-- 4. ����� ��������� ���������� ���������. ������� count, amount

SELECT  count(amount), amount FROM contract 
GROUP BY amount
having count(amount)>1



-- 5. ����� ��������� � ���������� ������� ���������� ����������. ������� customer_name, ������� �������� amount
-- ���� ���������� �  ���������� ������� ���������� ���������� �������� ����� ������ (��������� ����� ����� � ���������� ����������) ����� ���������������� ��� �������������, ����� ������ ����� ���� ������:

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

-- ���� �������, ��� ���������� ������� ��������� ���������� ������ � ������ ���������, �� ����:

SELECT cu.customer_name, ROUND(AVG(co.amount),0) AS average_cost_of_contracts FROM employees e 
	JOIN executor ex ON ex.tab_no = e.id
	JOIN contract co ON co.id = ex.contract_id
	JOIN customer cu ON cu.id = co.customer_id
GROUP BY cu.customer_name
ORDER BY AVG(co.amount)
ASC 
LIMIT 1




-- 6. ����� �����, ����������� ���������� �� ���������� �����. �������: department_name, sum
-- ������������ ������� ��������� �����������, ��� ��������� ��� ������, ���� �� ���������� ����� ���������� ����� �����

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
	
