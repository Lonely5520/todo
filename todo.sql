-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: todo_db
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) NOT NULL COMMENT '分类名称(全局唯一)',
  `color` varchar(20) NOT NULL DEFAULT '#9E9E9E' COMMENT '分类颜色',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'学习','#4CAF50','2026-06-24 00:12:42','2026-06-28 21:55:05'),(2,'工作','#2196F3','2026-06-24 00:12:42','2026-06-24 00:12:42'),(3,'生活','#FF9800','2026-06-24 00:12:42','2026-06-24 00:12:42'),(4,'运动','#F44336','2026-06-24 00:12:42','2026-06-24 00:12:42'),(5,'未分类','#9E9E9E','2026-06-24 00:12:42','2026-06-24 00:12:42'),(7,'紧急','#FF5722','2026-06-25 14:18:57','2026-06-25 14:18:57'),(10,'其他','#6C3FF5','2026-06-28 22:01:15','2026-06-28 22:01:15'),(11,'紧急11','#FF5722','2026-06-29 14:33:16','2026-06-29 14:33:16');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reminder_log`
--

DROP TABLE IF EXISTS `reminder_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reminder_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `task_id` bigint NOT NULL COMMENT '关联任务ID',
  `user_id` bigint NOT NULL COMMENT '接收用户ID',
  `message` varchar(500) NOT NULL COMMENT '提醒消息内容',
  `is_read` tinyint NOT NULL DEFAULT '0' COMMENT '已读状态:0-未读,1-已读',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '提醒生成时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_read` (`user_id`,`is_read`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='提醒记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reminder_log`
--

LOCK TABLES `reminder_log` WRITE;
/*!40000 ALTER TABLE `reminder_log` DISABLE KEYS */;
INSERT INTO `reminder_log` VALUES (1,1,2,'任务「学习 Spring Boot」即将到期，截止日期：2026-07-03T00:00',1,'2026-06-24 17:47:38'),(2,1,2,'任务「学习 Spring Boot」即将到期，截止日期：2026-07-03T00:00',1,'2026-06-24 23:20:34'),(3,5,3,'任务「222」即将到期，截止日期：2026-07-01T00:00',1,'2026-06-29 00:50:01'),(4,7,3,'任务「4444」即将到期，截止日期：2026-07-01T13:13',1,'2026-06-29 00:50:01'),(5,5,3,'任务「222」即将到期，截止日期：2026-07-01T00:00',0,'2026-06-29 14:01:42');
/*!40000 ALTER TABLE `reminder_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `user_id` bigint NOT NULL COMMENT '所属用户ID',
  `title` varchar(200) NOT NULL COMMENT '任务标题',
  `description` text COMMENT '任务描述',
  `priority` tinyint NOT NULL DEFAULT '1' COMMENT '优先级:0-低,1-中,2-高',
  `status` tinyint NOT NULL DEFAULT '0' COMMENT '状态:0-待办,1-进行中,2-已完成,3-已逾期',
  `category_id` bigint DEFAULT NULL COMMENT '所属分类ID(可为空表示未分类)',
  `due_date` datetime DEFAULT NULL COMMENT '截止日期',
  `remind_offset` int NOT NULL DEFAULT '1440' COMMENT '提醒偏移量(分钟),0=不提醒',
  `completed_time` datetime DEFAULT NULL COMMENT '完成时间',
  `is_deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除:0-正常,1-已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_status` (`user_id`,`status`,`is_deleted`),
  KEY `idx_user_deleted` (`user_id`,`is_deleted`),
  KEY `idx_due_date` (`due_date`),
  KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (1,2,'学习 Spring Boot','完成企业级应用开发课程设计',2,1,NULL,'2026-07-03 00:00:00',1440,NULL,0,'2026-06-24 17:17:54','2026-06-24 23:02:27'),(2,2,'测试删除恢复','这个任务将被删除然后恢复',1,0,NULL,NULL,1440,NULL,0,'2026-06-24 23:06:00','2026-06-24 23:12:38'),(3,3,'学习单词','每天10000个',2,2,1,'2026-06-29 17:06:09',1440,'2026-06-28 21:40:27',1,'2026-06-28 21:37:06','2026-06-28 21:41:13'),(4,3,'111','1111',1,2,1,'2026-06-30 00:00:00',1440,'2026-06-29 01:29:02',0,'2026-06-29 00:40:33','2026-06-29 01:29:02'),(5,3,'222','2222',0,1,3,'2026-07-01 00:00:00',1440,NULL,0,'2026-06-29 00:40:52','2026-06-29 01:33:51'),(6,3,'333','333',1,2,3,'2026-06-30 00:00:00',180,'2026-06-29 00:41:29',0,'2026-06-29 00:41:25','2026-06-29 00:41:29'),(7,3,'4444','4444',1,0,7,'2026-07-01 13:13:00',1440,NULL,0,'2026-06-29 00:41:52','2026-06-29 00:41:52'),(8,3,'555','555',1,3,4,'2026-06-29 06:43:23',15,NULL,0,'2026-06-29 00:42:40','2026-06-29 01:34:13'),(9,3,'666','',1,0,NULL,NULL,1440,NULL,0,'2026-06-29 15:05:00','2026-06-29 15:05:00');
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码(BCrypt加密)',
  `avatar_url` varchar(255) DEFAULT NULL COMMENT '用户头像路径',
  `role` tinyint NOT NULL DEFAULT '0' COMMENT '角色:0-普通用户,1-管理员',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态:0-禁用,1-正常',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','$2a$10$G7E619gGtRCi5JhF7kiQWO1D.qjg2nKTWJMZLvsSjUJLzwwn9pO/O',NULL,1,1,'2026-06-24 00:12:42','2026-06-29 15:00:59'),(2,'testuser2','$2a$10$Llmb8hQEuJXqbN38FjnaaewOHhiiXhEp0rqTcNtCXsb7ReGNMUrYK','/uploads/avatar/52b0ff97-aa5a-439a-99bc-dcf0902c8ea0.png',0,1,'2026-06-24 11:12:49','2026-06-29 14:22:29'),(3,'admin_n','$2a$10$bcKGjkiljGOx/vpH9O7GN.Cs8ACtFlWu6ba.viKrDe.D0i1FnVK3W','/uploads/avatar/f384b2d0-b267-4cdd-a65b-c02b250f4107.png',1,1,'2026-06-24 23:29:06','2026-06-28 23:54:54'),(4,'袁宸皓','$2a$10$DYwWJSDbB471f/LPZD7OJ.cAcq79BH0J5/1fIb5hqK7Wj1TEPAERu',NULL,0,1,'2026-06-28 21:29:23','2026-06-29 15:00:51');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-29 15:22:20
