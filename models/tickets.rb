# models a ticket
require_relative("../db/sql_runner")
require("pry")
require("logger")

$logger = Logger.new(STDOUT)
$logger.level = Logger::DEBUG

class Ticket

  attr_reader :id, :film_id, :customer_id

  def initialize(options)
    @id = options["id"] if options["id"]
    @film_id = options["film_id"].to_i
    @customer_id = options["customer_id"].to_i
  end

  def save
    sql = "INSERT INTO tickets (customer_id, film_id) values ($1,$2) returning *"
    params = [@customer_id, @film_id]
    @id = SqlRunner.run_insert(sql,params)
    $logger.debug("Inserted new Ticket with id #{@id}")
  end

  def self.delete_all
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql)
    $logger.warn("Deleted all tickets!!!")
  end

  def self.get_all
    sql = "SELECT * FROM tickets;"
    SqlRunner.run(sql).map {|hash| Ticket.new(hash)}
  end

  def delete
    if !@id
      # can't delete if not yet saved to DB!
      $logger.warn("Attempt to delete an unsaved record")
      return nil
    end
    sql = "DELETE FROM Tickets WHERE ID=$1"
    params = [@id]
    SqlRunner.run(sql, params)
    $logger.debug("Deleted Ticket with id #{@id}")
  end

  def update
    sql = "UPDATE tickets SET (customer_id, film_id) = ($1,$2) WHERE id=$3;"
    params = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, params)
    $logger.debug("Updated ticket with id #{@id}")
  end

end
