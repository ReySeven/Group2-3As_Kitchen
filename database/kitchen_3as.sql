-- ============================================================
--  3A's Kitchen Database
--  Import this in XAMPP phpMyAdmin
-- ============================================================

CREATE DATABASE IF NOT EXISTS kitchen_3as
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE kitchen_3as;

-- ── Users ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(120)        NOT NULL,
  email      VARCHAR(191)        NOT NULL UNIQUE,
  password   VARCHAR(255)        NOT NULL,
  role       ENUM('c','a','r')   NOT NULL DEFAULT 'c',
  created_at TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── Riders ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS riders (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    INT UNSIGNED        NOT NULL UNIQUE,
  mobile     VARCHAR(20)         NOT NULL,
  status     ENUM('Active','Resigned') NOT NULL DEFAULT 'Active',
  created_at TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ── Menu Items ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS items (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(191)   NOT NULL,
  description TEXT,
  price       DECIMAL(10,2)  NOT NULL,
  cost        DECIMAL(10,2)  NOT NULL DEFAULT 0,
  available   TINYINT(1)     NOT NULL DEFAULT 1,
  image       MEDIUMTEXT,
  deleted     TINYINT(1)     NOT NULL DEFAULT 0,
  created_at  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── Bundles ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bundles (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(191)   NOT NULL,
  description TEXT,
  price       DECIMAL(10,2)  NOT NULL,
  available   TINYINT(1)     NOT NULL DEFAULT 1,
  image       MEDIUMTEXT,
  deleted     TINYINT(1)     NOT NULL DEFAULT 0,
  created_at  TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── Bundle Items (which products are inside a bundle) ────────
CREATE TABLE IF NOT EXISTS bundle_items (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  bundle_id  INT UNSIGNED  NOT NULL,
  item_id    INT UNSIGNED  NOT NULL,
  quantity   INT UNSIGNED  NOT NULL DEFAULT 1,
  FOREIGN KEY (bundle_id) REFERENCES bundles(id) ON DELETE CASCADE,
  FOREIGN KEY (item_id)   REFERENCES items(id)
);

-- ── Orders ───────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id      INT UNSIGNED       NOT NULL,
  customer_name VARCHAR(120)      NOT NULL,
  address      TEXT               NOT NULL,
  want_date    DATE               NOT NULL,
  subtotal     DECIMAL(10,2)      NOT NULL,
  discount     DECIMAL(10,2)      NOT NULL DEFAULT 0,
  promo_code   VARCHAR(50)        NULL,
  delivery_fee DECIMAL(10,2)      NOT NULL DEFAULT 80,
  total        DECIMAL(10,2)      NOT NULL,
  status       ENUM('Pending','Accepted','Out for delivery','Delivered','Declined')
                                  NOT NULL DEFAULT 'Pending',
  decline_reason TEXT             NULL,
  rider_id     INT UNSIGNED       NULL,
  cash_collected TINYINT(1)       NOT NULL DEFAULT 0,
  proof_image  MEDIUMTEXT         NULL,
  created_at   TIMESTAMP          NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)   REFERENCES users(id),
  FOREIGN KEY (rider_id)  REFERENCES riders(id) ON DELETE SET NULL
);

-- ── Order Items ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
  id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id  INT UNSIGNED  NOT NULL,
  item_id   INT UNSIGNED  NOT NULL,
  quantity  INT UNSIGNED  NOT NULL DEFAULT 1,
  price     DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (item_id)  REFERENCES items(id)
);

-- ── Order Logs ───────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_logs (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id   INT UNSIGNED  NOT NULL,
  note       VARCHAR(255)  NOT NULL,
  logged_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- ── Promo Codes ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS promos (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code        VARCHAR(50)             NOT NULL UNIQUE,
  type        ENUM('%','₱')           NOT NULL DEFAULT '%',
  value       DECIMAL(10,2)           NOT NULL,
  min_order   DECIMAL(10,2)           NOT NULL DEFAULT 0,
  expires_on  DATE                    NOT NULL,
  enabled     TINYINT(1)              NOT NULL DEFAULT 1,
  usage_limit INT UNSIGNED            NULL,
  used_count  INT UNSIGNED            NOT NULL DEFAULT 0,
  once_per_user TINYINT(1)            NOT NULL DEFAULT 1,
  created_at  TIMESTAMP               NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── Expenses ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS expenses (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(255)  NOT NULL,
  amount      DECIMAL(10,2) NOT NULL,
  expense_date DATE          NOT NULL,
  created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ── Feedback ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS feedback (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id   INT UNSIGNED  NOT NULL UNIQUE,
  user_id    INT UNSIGNED  NOT NULL,
  rating     TINYINT       NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment    TEXT          NULL,
  created_at TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id)  REFERENCES users(id)
);

-- ── Seed: Default Admin Account ──────────────────────────────
-- Password: Admin@3a2024  (bcrypt hash)
INSERT IGNORE INTO users (name, email, password, role) VALUES (
  'Admin',
  'admin@3akitchen.com',
  '$2b$10$EeZH3QF1JGCDTJD3JqpQyeoMhctNlOo4MjrRA7Zvy7zoj817pBL/2',
  'a'
);

-- ── Seed: Sample Menu Items ──────────────────────────────────
INSERT IGNORE INTO items (id, name, description, price, cost, available) VALUES
  (1, 'Beef Caldereta',  'Rich tomato-based beef stew',      650.00, 300.00, 1),
  (2, 'Pancit Canton',   'Stir-fried noodles with vegetables', 450.00, 200.00, 1),
  (3, 'Steamed Rice',    'Per serving',                        50.00,  20.00, 1),
  (4, 'Lumpia Shanghai', '24 pieces per order',               380.00, 150.00, 1),
  (5, 'Chicken Adobo',   'Classic Filipino adobo',            600.00, 280.00, 1);

-- ── Seed: Sample Bundles ─────────────────────────────────────
INSERT IGNORE INTO bundles (id, name, description, price, available) VALUES
  (1, 'Family Fiesta Tray',  'Serves 8–10: adobo, pancit, lumpia, rice', 1850.00, 1),
  (2, 'Birthday Party Set',  'Serves 15–20: four mains and dessert',     3400.00, 1);

-- ── Seed: Bundle Items ───────────────────────────────────────
INSERT IGNORE INTO bundle_items (bundle_id, item_id, quantity) VALUES
  (1, 5, 1), (1, 2, 1), (1, 4, 1), (1, 3, 8),
  (2, 5, 2), (2, 1, 1), (2, 2, 2), (2, 4, 2), (2, 3, 15);
