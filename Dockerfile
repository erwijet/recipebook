FROM python:3.12-slim AS build

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false

RUN pip install "poetry==1.8.3"

WORKDIR /build

COPY pyproject.toml poetry.lock* README.md ./
RUN poetry install

COPY mkdocs.yml ./
COPY recipes ./recipes
COPY overrides ./overrides

RUN mkdocs build --strict --site-dir /site

FROM nginx:1.27-alpine AS serve
COPY --from=build /site /usr/share/nginx/html
