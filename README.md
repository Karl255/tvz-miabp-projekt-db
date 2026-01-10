# DB

Create Docker container (starts the container automatically):

```sh
docker run --name miabp-db -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=yourStrong(!)Password" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-latest1
```

Start it afterwards:

```sh
docker start miabp-db
```

# SQL code style

- DB objects - PascalCase
- columns/attributes - camelCase
