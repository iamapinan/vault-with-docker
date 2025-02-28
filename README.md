# Example of using Vault with Docker

## Prerequisites

- Docker

## Setup
1. Start Vault

```bash
docker-compose up -d
```

Now you can access the Vault UI at http://localhost:8200 and login with the token `root-token`. In this tutorial, we will use the Vault CLI to create a secret.

2. Access the Vault container shell

```bash
docker exec -it vault sh
```

3. Create a secret in Vault
```bash
# Set the Vault address and token
export VAULT_ADDR='http://localhost:8200'
export VAULT_TOKEN='root-token'

# Enable the kv secrets engine
vault secrets enable -version=1 kv

# Create a secret
vault kv put kv/mysql MYSQL_DATABASE=testdb MYSQL_USER=testuser MYSQL_PASSWORD=testpassword MYSQL_ROOT_PASSWORD=rootpassword
```

3. Create a policy for MySQL

```bash
vault policy write mysql-policy - <<EOF
path "kv/mysql" {
  capabilities = ["read", "list"]
}
EOF
```

4. Create a new token and apply the policy

```bash
vault token create -policy="mysql-policy"
```

You will get a `token` in the output, copy it.
```
# Example output
Key                  Value
---                  -----
token                hvs.CAESI-00000000-0000-0000-0000-000000000000
token_accessor       xxxxxxxxxxxxxxxxxxx
token_duration       768h
token_renewable      true
token_policies       ["default" "mysql-policy"]
identity_policies    []
policies             ["default" "mysql-policy"]
```

After create token exit the container
```bash
exit
```

### Outside the container
5. Update the `token` and `.env` files with the new token. In this step, you need to update the `token` and `.env` files with the new `token`.

```bash
echo "<token>" > ./vault-agent-config/token
echo "VAULT_CLIENT_ID=<token>\nVAULT_ADDR=http://vault:8200" > .env
```

6. Start the Vault agent
This will auto generate secrets files in `./secrets` directory.

```bash
docker-compose -f docker-compose.agent.yml up -d
```

7. Start the MySQL and PhpMyAdmin services

```bash
docker-compose -f docker-compose.mysql.yml up -d
```
Now you can access the PhpMyAdmin at [http://localhost:8000](http://localhost:8000) and the MySQL at [http://localhost:3306](http://localhost:3306) and login with the credentials in `./secrets/mysql.env`.


8. Check the MySQL container logs

```bash
docker-compose -f docker-compose.mysql.yml logs -f mysql
```

You should see the MySQL credentials being injected into the container.

## Cleanup

```bash
docker-compose -f docker-compose.mysql.yml down
```

Configure the Vault Agent to act as a proxy on port 8100

The Vault Agent is configured to act as a proxy on port 8100, allowing other services to access Vault secrets without directly connecting to Vault. This enhances security by limiting the exposure of Vault's credentials and simplifying the process of managing secrets across the system.

To utilize this proxy, services can connect to `http://localhost:8100` instead of directly accessing Vault. The Vault Agent will handle the authentication and retrieval of secrets on behalf of the services, ensuring a secure and efficient way to manage sensitive data.

This setup is particularly useful in scenarios where multiple services require access to Vault secrets, as it eliminates the need for each service to maintain its own connection to Vault.


## References

- [Vault Docker](https://hub.docker.com/r/hashicorp/vault)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

Contributors:
- [@iamapinan](https://github.com/iamapinan)

