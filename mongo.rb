require "mongo"
require "json"

### Create seed data

seed_data = {
	'shop' => 'Asos',
	'Price' => '$18.99',
	'title' => "test title"
}

### Standard URI format: mongodb://[dbuser:dbpassword@]host:port/dbname

uri = "mongodb://andy:weave2013@paulo.mongohq.com:10000/weave-dev"

client = Mongo::MongoClient.from_uri(uri)

db_name = uri[%r{/([^/\?]+)(\?|$)}, 1]
db = client.db(db_name)

# First we'll add a few songs. Nothing is required to create the songs 
# collection; it is created automatically when we insert.

products = db.collection("products")

# Note that the insert method can take either an array or a single dict.

products.insert(seed_data)

# Then we need to give Boyz II Men credit for their contribution to
# the hit "One Sweet Day"