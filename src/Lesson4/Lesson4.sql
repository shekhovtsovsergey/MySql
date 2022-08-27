/*Lesson4*/

/*1. Создать VIEW на основе пары любых запросов, из ДЗ к уроку 3.*/
CREATE VIEW AvarageSalary AS
SELECT
    dept_name as 'Отдел',
        AVG(s.salary) as 'Средняя ЗП'
FROM departments AS d
         LEFT JOIN dept_emp AS de ON d.dept_no = de.dept_no
         LEFT JOIN salaries AS s ON s.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
GROUP BY de.dept_no
order by dept_name ASC;



/*2. Создать функцию, которая выдаст ФИ менеджера по имени и фамилии сотрудника.*/
DROP FUNCTION IF EXISTS getManagerByEmployeName;
DELIMITER $
CREATE FUNCTION getManagerByEmployeName (firstName varchar(100), lastName varchar(100))
RETURNS varchar(200)
READS SQL DATA
BEGIN
RETURN(

    SELECT
        concat(e1.last_name, ' ', e1.first_name) as 'ФИО менеджера'
    FROM employees e1 WHERE e1.emp_no= (

        SELECT
            dm.emp_no
        FROM employees e
                 join dept_emp de on e.emp_no = de.emp_no and to_date = '9999-01-01'
                 join departments d on d.dept_no = de.dept_no
                 join dept_manager dm on d.dept_no = dm.dept_no
        where e.first_name = firstName
          and e.last_name = lastName
        limit 1)
);
END $
DELIMITER ;



/*3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.*/
DROP TRIGGER IF EXISTS trg_new_employee;
DELIMITER $
CREATE TRIGGER  trg_new_employee
    AFTER INSERT
    ON employees
    FOR EACH ROW
BEGIN
    INSERT INTO salaries
    SET emp_no = NEW.emp_no, salary = 10000, from_date = CURDATE(), to_date = '9999-01-01';
END $
DELIMITER;


/*проверка*/
DELETE FROM employees WHERE emp_no = 9999;
INSERT INTO employees (emp_no, first_name, last_name, gender, birth_date, hire_date)
VALUES (9999, 'Sergey',  'She',  'M', '1970-01-01',  CURDATE());
SELECT * FROM employees WHERE emp_no = 9999;