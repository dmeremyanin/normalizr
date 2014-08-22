ActiveRecord::Base.establish_connection \
  database: ':memory:',
  adapter:  'sqlite3',
  timeout:   500
