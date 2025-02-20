pid_file = "/tmp/vault-agent.pid"

vault {
  address = "http://vault:8200"
  retry {
    num_retries = 5
  }
}

auto_auth {
  method {
    type = "token_file"
    config = {
      token_file_path = "/vault/config/token"
    }
  }

  sink "file" {
    config = {
      path = "/vault/config/token"
    }
  }
}

template {
  source      = "/vault/config/mysql-root-password.tpl"
  destination = "/secrets/mysql_root_password"
}

template {
  source      = "/vault/config/mysql-database.tpl"
  destination = "/secrets/mysql_database"
}

template {
  source      = "/vault/config/mysql-user.tpl"
  destination = "/secrets/mysql_user"
}

template {
  source      = "/vault/config/mysql-password.tpl"
  destination = "/secrets/mysql_password"
} 

template {
  source      = "/vault/config/mysql.tpl"
  destination = "/secrets/mysql.env"
} 