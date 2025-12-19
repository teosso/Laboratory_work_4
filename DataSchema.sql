/* Створення таблиць (тільки структура та типи даних) */

CREATE TABLE users (
    user_id NUMERIC,
    user_name VARCHAR(50),
    role_name VARCHAR(20),
    CONSTRAINT users_pk PRIMARY KEY (user_id),
    -- Розбиваємо довгий рядок для лінтера
    CONSTRAINT user_name_template CHECK (
        user_name ~ '^[A-ZА-Я][a-zа-яА-Яa-zA-Z ]+$'
    )
);

CREATE TABLE admins (
    admin_id NUMERIC,
    user_id NUMERIC,
    access_level NUMERIC,
    CONSTRAINT admins_pk PRIMARY KEY (admin_id),
    CONSTRAINT admins_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    CONSTRAINT admin_level_range CHECK (access_level BETWEEN 1 AND 5)
);

CREATE TABLE data_objects (
    data_id NUMERIC,
    creator_id NUMERIC,
    data_name VARCHAR(100),
    data_content TEXT,
    created_at TIMESTAMP,
    CONSTRAINT data_objects_pk PRIMARY KEY (data_id),
    -- Розбиваємо рядок, який викликав помилку (було 83 символи)
    CONSTRAINT data_creator_fk FOREIGN KEY (creator_id)
        REFERENCES users (user_id),
    CONSTRAINT data_name_unique UNIQUE (data_name)
);

CREATE TABLE access_rights (
    right_id NUMERIC,
    user_id NUMERIC,
    action_rules VARCHAR(255),
    CONSTRAINT rights_pk PRIMARY KEY (right_id),
    CONSTRAINT rights_user_fk FOREIGN KEY (user_id) REFERENCES users (user_id),
    -- Переносимо регулярний вираз на новий рядок
    CONSTRAINT action_rules_template CHECK (
        action_rules
        ~ '^(READ|WRITE|DELETE|CREATE)(, (READ|WRITE|DELETE|CREATE))*$'
    )
);
