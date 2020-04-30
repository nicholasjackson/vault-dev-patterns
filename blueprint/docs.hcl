docs "docs" {
  path  = "./docs"
  port  = 18080

  index_title = "Vault"
  index_pages = [ 
    "index",
    "auth",
    "integration",
    "static",
    "db",
    "x509",
    "transit"
  ]

  network {
    name = "network.cloud"
  }
}