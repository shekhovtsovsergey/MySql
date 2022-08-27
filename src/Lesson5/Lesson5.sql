/*Транзакции


Написать пример транзакции.
Объединить логически связанные операции в одну транзакцию.
Например,
Транзакция Прием сотрудника на работу.
- вставка в таблицу сотрудников
- вставка в таблицу связки сотрудник-отдел
- вставка в таблицу зарплат зп для этого сотрудника
Часто повторяющуюся транзакцию оборачивают в хранимую процедуру.
Можно создать пример такой процедуры
add_new_employee(параметры)*/

DROP PROCEDURE IF EXISTS add_new_employee;
delimiter //
CREATE PROCEDURE add_new_employee(IN empNo INT, IN firstName varchar(100))
BEGIN
    START TRANSACTION;
    IF (SELECT emp_no FROM employees WHERE emp_no = empNo) > 1 THEN
        ROLLBACK;
        SELECT 'FAIL';
    ELSE
        INSERT INTO employees (emp_no, first_name, last_name, gender, birth_date, hire_date) VALUES (empNo, firstName, 'She',  'M', '1983-09-13',  CURDATE());
        INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date) VALUES (empNo, 'd008',  CURDATE(), '9999-01-01');
        /*зарплату вставляет триггер*/
        SELECT 'SUCCESS';
        COMMIT;
    END IF;
END//
delimiter;


/*Проверка*/
call add_new_employee(9999,'Sergey');

DELETE FROM employees WHERE emp_no = 9999;
DELETE FROM salaries  WHERE emp_no = 9999;
DELETE FROM dept_emp WHERE emp_no = 9999;

SELECT * FROM employees WHERE emp_no = 9999;
SELECT * FROM salaries WHERE emp_no = 9999;
SELECT * FROM dept_emp WHERE emp_no = 9999;


/*Проанализировать запрос с помощью EXPLAIN/ EXPLAIN ANALYZE
Выбрать запрос из предыдущих уроков.
Проанализировать использование индекса.
Сравнить быстродействие без индекса и с индексом.
В ответе выслать сам запрос, анализ и краткий вывод, что видим.*/

Explain
SELECT * FROM employees where first_name = 'Sergey';

ALTER TABLE `employees`.`employees` ADD INDEX `ix_first_name` (`first_name` ASC) VISIBLE;

ALTER TABLE `employees`.`employees`;
ALTER TABLE `employees`.`employees` ALTER INDEX `ix_first_name` INVISIBLE;


