Docker Odoo
=============

### Usage Docker

```shell
docker build . -t aartintelligent/odoo:latest
```

```shell
docker push aartintelligent/odoo:latest
```

### Usage Docker Compose

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

  odoo-mailer:
    image: maildev/maildev
    ports:
      - '1080:1080'
      - '1025:1025'

  odoo-database:
    image: postgres:17
    user: root
    restart: always
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=odoo
      - POSTGRES_PASSWORD=password
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - database-volume:/var/lib/postgresql/data
      #- /opt/postgres/data:/var/lib/postgresql/data
    ports:
      - '5432:5432'

  odoo-web:
    build:
      context: .
    user: root
    restart: always
    volumes:
      - ./mnt/enterprise:/mnt/enterprise:ro
      - ./mnt/dependencies:/mnt/dependencies:ro
      - ./mnt/addons:/mnt/addons:ro
      - odoo-volume:/var/lib/odoo
      #- /opt/odoo/data:/var/lib/odoo
    ports:
      - '8069:8069'
      - '8071:8071'
      - '8072:8072'

volumes:
  database-volume:
  odoo-volume:
```