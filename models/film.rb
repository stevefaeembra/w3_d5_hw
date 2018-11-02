# models a film
require_relative("../db/sql_runner")
require("pry")
require("logger")

$logger = Logger.new(STDOUT)
$logger.level = Logger::DEBUG

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options["id"] if options["id"]
    @title = options["title"]
    @price = options["price"].to_f
  end

  def save
    sql = "INSERT INTO films (title, price) values ($1,$2) returning *"
    params = [@title, @price]
    @id = SqlRunner.run_insert(sql,params)
    $logger.debug("Inserted new Film with id #{@id}")
  end

  def self.delete_all
    sql = "DELETE FROM films;"
    SqlRunner.run(sql)
    $logger.warn("Deleted all films!!!")
  end

  def self.get_all
    sql = "SELECT * FROM films;"
    SqlRunner.run(sql).map {|hash| Film.new(hash)}
  end

  def delete
    if !@id
      # can't delete if not yet saved to DB!
      $logger.warn("Attempt to delete an unsaved record")
      return nil
    end
    sql = "DELETE FROM Films WHERE ID=$1"
    params = [@id]
    SqlRunner.run(sql, params)
    $logger.debug("Deleted Film with id #{@id}")
  end

  def update
    sql = "UPDATE films SET (title, price) = ($1,$2) WHERE id=$3;"
    params = [@title, @price, @id]
    SqlRunner.run(sql, params)
    $logger.debug("Updated film with id #{@id}")
  end

  def customers
    sql = '-- film to many customers

            select
	            customers.*
            from
	            films
	            inner join tickets on films.id = tickets.film_id
	            inner join customers on tickets.customer_id = customers.id
            where
	            films.id = $1
            order by
	            films.id asc
    '
    params = [@id]
    results = SqlRunner.run(sql, params)
    results.map {|hash| Customer.new(hash)}
  end
end
