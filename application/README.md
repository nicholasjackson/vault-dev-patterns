# Example applicaiton

## Endpoints

The example application is a simple Go based API with two endpoints

### Products

Returns a list of products stored in a PostgreSQL database

#### Path 

```
/ 
```

#### Request

```
empty request
```

#### Response
List of coffees returned as JSON

```go
[]Coffee {
	ID          int                 `db:"id" json:"id"`
	Name        string              `db:"name" json:"name"`
	Teaser      string              `db:"teaser" json:"teaser"`
	Description string              `db:"description" json:"description"`
	Price       float64             `db:"price" json:"price"`
	Image       string              `db:"image" json:"image"`
	CreatedAt   string              `db:"created_at" json:"-"`
	UpdatedAt   string              `db:"updated_at" json:"-"`
	DeletedAt   sql.NullString      `db:"deleted_at" json:"-"`
	Ingredients []CoffeeIngredients `json:"ingredients"`
}

[]CoffeeIngredient {
	ID        int            `db:"id" json:"id"`
	Name      string         `db:"name" json:"name"`
	Quantity  int            `db:"quantity" json:"quantity"`
	Unit      string         `db:"unit" json:"unit"`
	CreatedAt string         `db:"created_at" json:"-"`
	UpdatedAt string         `db:"updated_at" json:"-"`
	DeletedAt sql.NullString `db:"deleted_at" json:"-"`
}
```

### Pay
Fake payments endpoint which encrypts credit card numbers using HashiCorp Vault

#### Path
/pay

#### Request
Credit card number sent as a JSON payload

```
PayRequest {
	CardNumber string `json:"card_number"`
}
```

#### Response
Encrypted credit card number as a JSON payload

```
type PayResponse struct {
	CipherText string `json:"ciphertext"`
}
```

## Configuration

To configure the application a JSON formatted config files is required.

The location of the config file can be specified using the `CONFIG_FILE` environment variables

### Example

```
{
  "db_connection": "host=localhost port=15432 user=postgres password=password dbname=products sslmode=disable",
  "bind_address": ":9091",
  "vault_addr": "http://localhost:18200",
  "vault_token_file": "./.vault_token"
}
```

### Parameters

#### db_connection - string, optional
PostgreSQL connection string pointing to the Products database. If not specified the application will start but the `Products` endpoint will not 
function.

#### bind_address - string, required
Bind address for the server specifying `IP` address and `Port`.

#### vault_addr - string, optional
URI for Vault API. If not specified the `Pay` endpoint will not function.

#### vault_token_file - string, optional
Path to a file containing a valid Vault token. If not specified the `Pay` endpoint will not function.

#### tls_cert_file - string, optional
Path to a valid pem encoded X509 certificate to be used to configure TLS. If either `tls_cert_file` or `tls_key_file` is not 
specified the API will default to plain HTTP.

#### tls_key_file - string, optional
Path to a valid pem encoded private key used to configure TLS. If either `tls_cert_file` or `tls_key_file` is not 
specified the API will default to plain HTTP.