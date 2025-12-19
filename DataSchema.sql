/* Створення таблиць (тільки структура та типи даних) */

CREATE TABLE users (
    user_id NUMERIC,
    user_name VARCHAR(50),
    role_name VARCHAR(20)
);

CREATE TABLE admins (
    admin_id NUMERIC,
    user_id NUMERIC,
    access_level NUMERIC
);

CREATE TABLE data_objects (
    data_id NUMERIC,
    creator_id NUMERIC,
    data_name VARCHAR(100),
    data_content TEXT,
    created_at TIMESTAMP
);

CREATE TABLE access_rights (
    right_id NUMERIC,
    user_id NUMERIC,
    action_rules VARCHAR(255)
);

/* Команди обмеження цілісності даних */

-- Встановлення первинних ключів (PRIMARY KEY)
ALTER TABLE users ADD CONSTRAINT users_pk PRIMARY KEY (user_id);
ALTER TABLE admins ADD CONSTRAINT admins_pk PRIMARY KEY (admin_id);
ALTER TABLE data_objects ADD CONSTRAINT data_objects_pk PRIMARY KEY (data_id);
ALTER TABLE access_rights ADD CONSTRAINT rights_pk PRIMARY KEY (right_id);

-- Встановлення зовнішніх ключів (FOREIGN KEY)
ALTER TABLE admins ADD CONSTRAINT admins_user_fk 
    FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE data_objects ADD CONSTRAINT data_creator_fk 
    FOREIGN KEY (creator_id) REFERENCES users(user_id);

ALTER TABLE access_rights ADD CONSTRAINT rights_user_fk 
    FOREIGN KEY (user_id) REFERENCES users(user_id);

-- Встановлення унікальності для назви даних
ALTER TABLE data_objects ADD CONSTRAINT data_name_unique UNIQUE (data_name);

-- Встановлення обмежень вмісту (CHECK)
ALTER TABLE admins ADD CONSTRAINT admin_level_range
    CHECK (access_level BETWEEN 1 AND 5);

-- Обмеження через регулярні вирази (Regex)
-- Ім'я: Починається з великої літери, далі літери та пробіли
ALTER TABLE users ADD CONSTRAINT user_name_template
    CHECK (user_name ~ '^[A-ZА-Я][a-zа-яА-Яa-zA-Z ]+$');

-- Правила: Дозволені операції READ, WRITE, DELETE, CREATE через кому
ALTER TABLE access_rights ADD CONSTRAINT action_rules_template
    CHECK (action_rules ~ '^(READ|WRITE|DELETE|CREATE)(, (READ|WRITE|DELETE|CREATE))*$');
