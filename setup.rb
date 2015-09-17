require 'pry-nav' # in case you want to use binding.pry
require 'active_record'
require 'colorize'
require_relative 'contact'

# Output messages from Active Record to standard out
# ActiveRecord::Base.logger = Logger.new(STDOUT)

# puts 'Establishing connection to database ...'
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'contactlist',
  username: 'ruxica',
  # password: 'development',
  host: '',
  port: 5432,
  pool: 5,
  encoding: 'unicode',
  min_messages: 'error'
)
# puts 'CONNECTED'

# puts 'Setting up Database (creating tables) ...'

# ActiveRecord::Schema.define do
#   # drop_table :contacts if ActiveRecord::Base.connection.table_exists?(:contacts)
#   # drop_table :phone_numbers if ActiveRecord::Base.connection.table_exists?(:phone_numbers)

#   unless ActiveRecord::Base.connection.table_exists?(:contacts)
#     create_table :contacts do |t|
#       t.column :firstname, :string
#       t.column :lastname, :string
#       t.column :email, :string
#       t.timestamps null: false
#     end
#   end

#   unless ActiveRecord::Base.connection.table_exists?(:phone_numbers)
#     create_table :phone_numbers do |table|
#       table.references :contact
#       table.column :number, :string
#       table.column :type, :string
#       table.timestamps null: false
#     end
#   end
# end

# puts 'Setup DONE'
