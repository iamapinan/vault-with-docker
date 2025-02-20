# Example of using Vault to store secrets and inject them into a container

## Prerequisites

- Docker
- Vault

## Setup

1. Start Vault

```bash
docker-compose up -d
```

2. Create a secret in Vault

```bash
vault kv put kv/mysql MYSQL_DATABASE=testdb MYSQL_USER=testuser MYSQL_PASSWORD=testpassword MYSQL_ROOT_PASSWORD=rootpassword
```

3. Start the MySQL container and Vault agent

```bash
docker-compose -f docker-compose.mysql.yml up -d
```

4. Check the MySQL container logs

```bash
docker-compose -f docker-compose.mysql.yml logs -f mysql
```

You should see the MySQL credentials being injected into the container.

## Cleanup

```bash
docker-compose -f docker-compose.mysql.yml down
```
