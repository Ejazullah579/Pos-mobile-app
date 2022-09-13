CREATE TABLE daily_history(
  id INTEGER PRIMARY KEY autoincrement,
  user_id Text,
  date Text,
  amount Float,
  totalProductsSoled INTEGER
);

CREATE TABLE weekly_history(
  id INTEGER PRIMARY KEY autoincrement,
  user_id Text,
  date Text,
  amount Float,
  totalProductsSoled INTEGER
);

CREATE TABLE monthly_history(
  id INTEGER PRIMARY KEY autoincrement,
  user_id Text,
  date Text,
  amount Float,
  totalProductsSoled INTEGER
);