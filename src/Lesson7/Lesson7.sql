-- **************************************************************************************************
-- ****************************************   Задача 1   *********************************************
-- Права доступа
-- 1. Создать нового пользователя и задать ему права доступа на базу данных «Страны и города мира».
CREATE USER 'user'@'localhost' IDENTIFIED BY 'user';
SELECT user,host FROM mysql.user;
GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost';
FLUSH PRIVILEGES;


-- **************************************************************************************************
-- ****************************************   Задача 1   *********************************************
-- Задачи к собеседованию
-- Задача 1
-- У вас есть социальная сеть, где пользователи (id, имя) могут ставить друг другу лайки.
-- Создайте необходимые таблицы для хранения данной информации.

CREATE SCHEMA `social` ;

CREATE TABLE IF NOT EXISTS `social`.`users` (
                                  `id_user` INT NOT NULL AUTO_INCREMENT,
                                  `login` VARCHAR(45) NOT NULL,
                                  PRIMARY KEY (`id_user`));

CREATE TABLE IF NOT EXISTS `social`.`likes` (
                                  `id_like` INT NOT NULL AUTO_INCREMENT,
                                  `user_from` INT NOT NULL,
                                  `user_to` INT NOT NULL,
                                  PRIMARY KEY (`id_like`),
                                  INDEX `fk_likes_users_idx` (`user_from` ASC) VISIBLE,
                                  INDEX `fk_likes_users_2_idx` (`user_to` ASC) VISIBLE,
                                  CONSTRAINT `fk_likes_users_1`
                                      FOREIGN KEY (`user_from`)
                                          REFERENCES `social`.`users` (`id_user`)
                                          ON DELETE NO ACTION
                                          ON UPDATE NO ACTION,
                                  CONSTRAINT `fk_likes_users_2`
                                      FOREIGN KEY (`user_to`)
                                          REFERENCES `social`.`users` (`id_user`)
                                          ON DELETE NO ACTION
                                          ON UPDATE NO ACTION);


INSERT INTO social.users (login) VALUES ('natasha');
INSERT INTO social.users (login) VALUES ('katya');
INSERT INTO social.users (login) VALUES ('anna');

INSERT INTO social.likes (user_from, user_to) VALUES (1,2);
INSERT INTO social.likes (user_from, user_to) VALUES (1,3);
INSERT INTO social.likes (user_from, user_to) VALUES (2,1);
INSERT INTO social.likes (user_from, user_to) VALUES (2,3);
INSERT INTO social.likes (user_from, user_to) VALUES (3,1);
INSERT INTO social.likes (user_from, user_to) VALUES (3,2);


-- Создайте запрос, который выведет информацию:
    -- id пользователя;
    -- имя;
    -- лайков получено;
    -- лайков поставлено;
    -- взаимные лайки.

-- Взаимные лайки
CREATE OR REPLACE VIEW social.V AS
SELECT

    distinct(l.user_from),
    count(*) OVER (PARTITION BY l.user_from) AS mutal

FROM (
         SELECT
             user_from,
             user_to
         FROM social.likes
         ORDER BY user_from) l

            LEFT JOIN (

                        SELECT
                            user_to,
                            user_from
                        FROM social.likes
                        ORDER BY user_to) r ON l.user_from = r.user_to

WHERE l.user_from = r.user_to
  AND l.user_to = r.user_from
ORDER BY l.user_from;


-- Итоговый запрос
SELECT
    q1.id_user,
    q1.login,
    q1.Лайков_получено,
    count(lf.id_like) as Лайков_поставлено,
    count(v1.mutal) as Взаимных_лайков

FROM
    (SELECT
         u.id_user,
         u.login,
         count(lt.id_like) as Лайков_получено
     FROM social.users u
              LEFT JOIN social.likes lt on u.id_user = lt.user_to
     group by
         u.id_user,
         u.login) q1

        LEFT JOIN social.likes lf on q1.id_user = lf.user_from
        LEFT JOIN social.V v1 on q1.id_user = v1.user_from

GROUP BY
    q1.id_user,
    q1.login,
    q1.Лайков_получено;



-- **************************************************************************************************
-- ****************************************   Задача 2   *********************************************
-- Для структуры из задачи 1 выведите список всех пользователей, которые поставили лайк
-- пользователям A и B (id задайте произвольно), но при этом не поставили лайк пользователю C.

SELECT
       u.login AS name,
       SUM(
               CASE l.user_to
                   WHEN 4 THEN 1
                   WHEN 5 THEN 1
                   WHEN 2 THEN -1
                   ELSE 0
                   END) AS count_of_likes
FROM users u
         JOIN likes l ON (u.id_user = l.user_from)
GROUP BY name
HAVING count_of_likes > 1;