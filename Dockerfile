ARG ODOO_VERSION=18.0

FROM odoo:${ODOO_VERSION}

USER root

COPY --chown=odoo mnt /mnt

RUN set -e; \
    for dir in /mnt/dependencies /mnt/addons; do \
        find "$dir" -name 'requirements.txt' | while read requirements; do \
            if [ -s "$requirements" ]; then \
                if ! pip install -r "$requirements"; then \
                    echo "Failed to install requirements from $requirements"; \
                    exit 1; \
                fi; \
            fi; \
        done; \
    done

RUN sed -i 's|/mnt/extra-addons|/mnt/enterprise,/mnt/dependencies,/mnt/addons|' /etc/odoo/odoo.conf

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 8069 8071 8072

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["odoo"]

USER odoo
