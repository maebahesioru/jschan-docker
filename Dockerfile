FROM node:22-bookworm

RUN apt-get update -y && apt-get install -y ffmpeg imagemagick graphicsmagick && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Copy package files first for better layer caching
COPY package.json package-lock.json ./
RUN npm install

RUN npm install -g pm2 gulp

# Copy source code
COPY . .

# Use our custom secrets.js with env var support
COPY secrets.js ./configs/secrets.js

ENV MONGO_USERNAME=jschan
ENV MONGO_PASSWORD=changeme
ENV REDIS_PASSWORD=changeme
ENV MONGO_HOST=mongodb
ENV REDIS_HOST=redis

# Expose port 7000
EXPOSE 7000

CMD ["/bin/sh", "-c", "npx gulp generate-favicon && npx gulp && pm2-runtime start ecosystem.config.js"]
