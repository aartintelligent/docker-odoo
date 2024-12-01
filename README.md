Docker Odoo
=============

### Usage

Docker

```shell
docker build . -t aartintelligent/odoo:18.0
```

```shell
docker push aartintelligent/odoo:18.0
```

Docker Compose

```shell
docker compose build
```

```shell
docker compose up -d
```

```shell
docker compose down -v
```

### Compose

```yaml
services:

  database:
    image: postgres:16
    user: root
    restart: always
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=odoo
      - POSTGRES_PASSWORD=password
    volumes:
      - database-volume:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  odoo:
    build:
      context: .
    command: --
    restart: always
    tty: true
    volumes:
      - ./enterprise:/mnt/enterprise:ro
      - ./addons:/mnt/addons:ro
      - odoo-volume:/var/lib/odoo
    depends_on:
      - database
    ports:
      - "8089:8069"
      - "8072:8072"

volumes:
  database-volume:
  odoo-volume:
```