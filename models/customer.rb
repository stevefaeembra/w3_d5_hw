# models a customer
require_relative("../db/sql_runner")
require("pry")
require("logger")

$logger = Logger.new(STDOUT)
$logger.level = Logger::DEBUG

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options["id"] if options["id"]
    @name = options["name"]
    @funds = options["funds"].to_f
  end

  def save
    sql = "INSERT INTO customers (name, funds) values ($1,$2) returning *"
    params = [@name, @funds]
    @id = SqlRunner.run_insert(sql,params)
    $logger.debug("Inserted new Customer with id #{@id}")
  end

  def self.delete_all
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
    $logger.warn("Deleted all customers!")
  end

  def self.get_all
    sql = "SELECT * FROM customers;"
    SqlRunner.run(sql).map {|hash| Customer.new(hash)}
  end

  def delete
    if !@id
      # can't delete if not yet saved to DB!
      $logger.warn("Attempt to delete an unsaved record")
      return nil
    end
    sql = "DELETE FROM Customers WHERE ID=$1"
    params = [@id]
    SqlRunner.run(sql, params)
    $logger.debug("Deleted customer with id #{@id}")
  end

  def update
    sql = "UPDATE customers SET (name, funds) = ($1,$2) WHERE id=$3;"
    params = [@name, @funds, @id]
    SqlRunner.run(sql, params)
    $logger.debug("Updated customer with id #{@id}")
  end

  def films
    # list movies for a given customer
    sql = '
      select
	      films.*
      from
	      customers
	      inner join tickets on customers.id = tickets.customer_id
	      inner join films on tickets.film_id = films.id
      where
	      customers.id = $1
      order by
	      id asc
    '
    params = [@id]
    result = SqlRunner.run(sql, params)
    result.map {|hash| Film.new(hash)}
  end

end
