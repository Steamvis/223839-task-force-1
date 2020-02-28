DROP DATABASE IF EXISTS taskForce;
CREATE DATABASE taskForce
	COLLATE UTF8_GENERAL_CI;
USE taskForce;

-- таблица городов
CREATE TABLE `cities` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`city` VARCHAR(50) NOT NULL,
	`lat` FLOAT NOT NULL,
	`long` FLOAT NOT NULL,
	UNIQUE KEY `lat`(`lat`),
	UNIQUE KEY `long`(`long`)
)
	ENGINE = INNODB;
-- таблица категорий
CREATE TABLE `categories` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL,
	UNIQUE KEY `name`(`name`)
)
	ENGINE = INNODB;
-- таблица пользователей
CREATE TABLE `users`(
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(30) NOT NULL,
	`last_name` VARCHAR(50) NULL,
	`city_id` INT UNSIGNED NULL,
	`email` VARCHAR(50) NOT NULL,
	`phone` VARCHAR(11) NOT NULL,
	`password` CHAR(32) NOT NULL,
	`birthday` DATE NULL,
	`role` ENUM('customer', 'performer') NOT NULL,
	`is_public` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
	`avatar` VARCHAR(255) NOT NULL DEFAULT 'placeholderUser.jpg',
	`date_joined` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`last_activity` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`skype` VARCHAR(50) NULL,
	`telegram` VARCHAR(50) NULL,
	`biography` TEXT NULL,
	UNIQUE KEY `email`(`email`),
	UNIQUE KEY `phone`(`phone`),
	FOREIGN KEY (`city_id`) REFERENCES `cities`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
	ENGINE = INNODB;
-- таблица задач
CREATE TABLE `tasks` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`title` VARCHAR(255) NOT NULL,
	`created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated_at` DATETIME NULL,
	`price` INT UNSIGNED NULL,
	`city_id` INT UNSIGNED NULL,
	`lat` INT(10), -- широта
	`lon` INT(10), -- долгота
	`description` TEXT NOT NULL,
	`category_id` INT UNSIGNED NOT NULL,
	`performer_id` INT UNSIGNED NULL,
	`author_id` INT UNSIGNED NOT NULL,
	`status` TINYINT NOT NULL,
	FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (`author_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (`performer_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (`city_id`) REFERENCES `cities`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
	ENGINE = INNODB;
-- таблица специализаций пользователя
CREATE TABLE `user_specializations` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`performer_id` INT UNSIGNED NOT NULL,
	`category_id` INT UNSIGNED NOT NULL,
	FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (`performer_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
	ENGINE = INNODB;
-- таблица откликов на задачи
CREATE TABLE `responses` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`task_id` INT UNSIGNED NOT NULL,
	`performer_id` INT UNSIGNED NOT NULL,
	`response_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`text` TEXT NOT NULL,
	`offer_price` INT UNSIGNED NULL,
	UNIQUE KEY (`task_id`, `performer_id`),
	FOREIGN KEY (`task_id`) REFERENCES `tasks`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (`performer_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
	ENGINE = INNODB;
-- таблица чатов
CREATE TABLE `chats` (
	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT
)
	ENGINE = INNODB;
-- таблица сообщений чатов
CREATE TABLE `chat_messages` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`chat_id` INT UNSIGNED NOT NULL,
	`author_id` INT UNSIGNED NOT NULL,
	`recipient_id` INT UNSIGNED NOT NULL,
	`created_at` INT UNSIGNED NOT NULL,
	`text` VARCHAR(5000) NOT NULL,
	FOREIGN KEY (`chat_id`) REFERENCES `chats`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (`author_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (`recipient_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
	ENGINE = INNODB;
-- таблица отмеченных пользователей
CREATE TABLE `bookmarked_users` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`user_id` INT UNSIGNED NOT NULL,
	`bookmarked_user_id` INT UNSIGNED NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (`bookmarked_user_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
	ENGINE = INNODB;
-- таблица пользовательских файлов
CREATE TABLE `users_media` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`thumbnail_path` VARCHAR(255) NOT NULL,
	`media_path` VARCHAR(255) NOT NULL,
	`user_id` INT UNSIGNED NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
	ENGINE = INNODB;
-- таблица отзывов
CREATE TABLE `reviews` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`customer_id` INT UNSIGNED NOT NULL,
	`performer_id` INT UNSIGNED NOT NULL,
	`text` TEXT NULL,
	`raiting` TINYINT UNSIGNED NULL,
	`created_at`	 DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (`customer_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (`performer_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
	ENGINE = INNODB;
-- таблица уведомлений
CREATE TABLE `notification` (
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`user_id` INT UNSIGNED NOT NULL,
	`task_responce` TINYINT(1) UNSIGNED NOT NULL,
	`task_refusal` TINYINT(1) UNSIGNED NOT NULL,
	`task_start` TINYINT(1) UNSIGNED NOT NULL,
	`task_complete` TINYINT(1) UNSIGNED NOT NULL,
	`new_chat_message` TINYINT(1) UNSIGNED NOT NULL,
	UNIQUE KEY `user_id`(`user_id`),
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
	ENGINE = INNODB;
