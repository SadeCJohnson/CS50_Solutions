-- USERS TABLE
CREATE TABLE users
  (
     id       INTEGER,
     username TEXT NOT NULL,
     hash     TEXT NOT NULL,
     cash     NUMERIC NOT NULL DEFAULT 10000.00,
     PRIMARY KEY(id)
  );

CREATE TABLE IF NOT EXISTS transactions
  (
     user_id          INTEGER NOT NULL,
     ownership_status BIT NOT NULL,
     ticker_symbol    TEXT NOT NULL,
     amount           INTEGER NOT NULL,
     purchase_price   DECIMAL(9,2) NOT NULL,
     transaction_time DATETIME NOT NULL,
     FOREIGN KEY(user_id) REFERENCES users (id)
  );