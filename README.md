# Example of using Vault to store secrets and inject them into a container

## Prerequisites

- Docker
- Vault

## Setup

1. Start Vault

```bash
docker-compose up -d
```


2. Access the Vault container shell

```bash
docker exec -it vault sh
```

3. Create a secret in Vault
```bash
# Set the Vault address and token
export VAULT_ADDR='http://localhost:8200'
export VAULT_TOKEN='root-token'

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

You will get a token `client_id` in the output, copy it.

5. Update the `token` and `.env` files with the new client_id

In this step, you need to update the `token` and `.env` files with the new `client_id` outside the container.

```bash
echo "<client_id>" > ./vault-agent-config/token
echo "VAULT_CLIENT_ID=<client_id>" > .env
```

6. Start the MySQL container and Vault agent

```bash
docker-compose -f docker-compose.mysql.yml up -d
```

7. Check the MySQL container logs

```bash
docker-compose -f docker-compose.mysql.yml logs -f mysql
```

You should see the MySQL credentials being injected into the container.

## Cleanup

```bash
docker-compose -f docker-compose.mysql.yml down
```
