# ---------- Builder ----------
FROM python:3.13-slim-bookworm AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir --prefix=/install -r requirements.txt

COPY . .

# ---------- Runtime ----------
FROM cgr.dev/chainguard/python:latest

WORKDIR /app

COPY --from=builder /install /usr/local
COPY --from=builder /app .

USER nonroot

EXPOSE 5000

CMD ["app.py"]