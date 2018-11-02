# driver program
require("pry")
require_relative('models/customer')
require_relative('models/film')
require_relative('models/tickets')
require("logger")

$logger = Logger.new(STDOUT)
$logger.level = Logger::DEBUG

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

# Customer setup
customer1 = Customer.new({"name" => "Steven", "funds" =>100.0})
customer1.delete() # should error as not yet saved to db
customer1.save()
customer1.name = "Steven Kay"
customer1.funds = 105.00
customer1.update()
customer2 = Customer.new({"name" => "Andy", "funds" =>120.0})
customer2.save()
customer3 = Customer.new({"name" => "Julie", "funds" =>450.0})
customer3.save()

results = Customer.get_all()
for f in results
  $logger.debug("Found customer #{f}")
end

# Film setup

film1 = Film.new({"title" => "Solo", "price" => 4.50})
film2 = Film.new({"title" => "Avengers - Infinity War", "price" => 5.50})
film3 = Film.new({"title" => "Rogue One", "price" => 3.00})

film1.save()
film2.save()
film3.save()

film1.price *= 1.10
film1.update()

# lets get some Tickets

ticket1 = Ticket.new({"film_id" => film1.id, "customer_id" => customer1.id})
ticket1.save
ticket2 = Ticket.new({"film_id" => film1.id, "customer_id" => customer2.id})
ticket2.save
ticket3 = Ticket.new({"film_id" => film1.id, "customer_id" => customer3.id})
ticket3.save
ticket4 = Ticket.new({"film_id" => film2.id, "customer_id" => customer1.id})
ticket4.save
ticket5 = Ticket.new({"film_id" => film3.id, "customer_id" => customer1.id})
ticket5.save
ticket6 = Ticket.new({"film_id" => film3.id, "customer_id" => customer3.id})
ticket6.save

# get movies from customer
movie_list = customer1.films()
$logger.debug("#{p movie_list}")

# get customers for a movie
customer_list = film1.customers()
$logger.debug("#{p customer_list}")
