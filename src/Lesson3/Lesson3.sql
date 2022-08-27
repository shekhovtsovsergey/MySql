/*Lesson3*/

/*База данных «Страны и города мира»*/

/*1.1 Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
Выводимые поля в ответе:
Наименование страны, наименование региона, наименование города.
Сортировка по всем полям по возрастанию.*/
select
    c.title as 'Страна',
        r.title as 'Регион',
        cc.title as 'Город'
from _countries c
         left join _regions r on c.id=r.country_id
         left join _cities cc on r.id=cc.region_id
order by
    c.title ASC,
    r.title ASC,
    cc.title ASC;


/*1.2 Выбрать все города из Московской области.
Выводимые поля в ответе:
Наименование города.
Сортировка по возрастанию.*/
select
    c.title as 'Город'
from _regions r
    LEFT OUTER JOIN _cities c on r.id = c.region_id
where r.title = 'Московская область'
order by c.title ASC;


/*База данных «Сотрудники»*/

/*2.1 Выбрать среднюю зарплату по отделам.
Выводимые поля в ответе:
Наименование отдела, средняя ЗП.
Сортировка по наименованию отдела.*/
SELECT
    dept_name as 'Отдел',
        AVG(s.salary) as 'Средняя ЗП'
FROM departments AS d
         LEFT JOIN dept_emp AS de ON d.dept_no = de.dept_no
         LEFT JOIN salaries AS s ON s.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
GROUP BY de.dept_no
order by dept_name ASC;



/*2.2 Выбрать максимальную зарплату у сотрудника.
Выводимые поля в ответе:
Наименование отдела, ФИО сотрудника (сцепить имя и фамилию), максимальная ЗП.
Сортировка по наименованию отдела по возрастанию, максимальной ЗП по убыванию.*/
SELECT
    d.dept_name as 'Отдел',
        concat(e.last_name, ' ', e.first_name) as 'ФИО сотрудника',
        MAX(s.salary) as 'Максимальная ЗП'
FROM salaries s
         left join employees e on s.emp_no = e.emp_no
         left join dept_emp de on e.emp_no = de.emp_no
         left join departments d on de.dept_no = d.dept_no
WHERE de.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
GROUP BY
    d.dept_name,
    concat(e.last_name, ' ', e.first_name)
order by d.dept_name ASC, MAX(s.salary) DESC;


/*2.3 Удалить одного сотрудника, у которого максимальная зарплата.
Выводимые поля в ответе:
Ничего не выводим, составляем скрипт на удаление.*/
DELETE FROM employees
WHERE emp_no IN
      (SELECT salaries.emp_no FROM salaries
       WHERE salary = (SELECT MAX(salary) FROM salaries));


/*2.4 Посчитать количество сотрудников во всех отделах.
Выводимые поля в ответе:
Количество сотрудников (одно число).*/
SELECT
    COUNT(de.emp_no) AS 'Кол-во сотрудников'
FROM dept_emp de
where de.to_date = '9999-01-01';



/*2.5 Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
Выводимые поля в ответе:
Наименование отдела, Количество сотрудников, сумма ЗП всех сотрудников.
Сортировка по наименованию отдела по возрастанию.
NB! У каждого сотрудника есть несколько записей о зп, выбираем только последнюю максимальную ЗП!*/
select
    d.dept_name as 'Отдел',
        sum(s1.max) as 'Сумма Максимальной ЗП',
        count(s1.max) as 'Кол-во сотрудников'
from
    (select
         s.emp_no,
         max(s.salary) as 'max',
             de.dept_no
     from salaries s
              left join dept_emp de on s.emp_no = de.emp_no
     WHERE de.to_date = '9999-01-01' AND s.to_date = '9999-01-01'
     group by s.emp_no,de.dept_no
    ) as s1
left join departments d on d.dept_no = s1.dept_no
group by d.dept_name
order by d.dept_name ASC;