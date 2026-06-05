FROM node:22-bookworm

RUN apt-get update -y && apt-get install -y ffmpeg imagemagick graphicsmagick && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

COPY package.json package-lock.json ./
RUN npm install

RUN npm install -g pm2 gulp

COPY . .
COPY ./docker/jschan/secrets.js ./configs/secrets.js

# Skip gulp generate-favicon since it seems to require DB connection
# Instead, just set up the env
ENV MONGO_USERNAME=jschan
ENV MONGO_PASSWORD=changeme
ENV REDIS_PASSWORD=changeme

# Generate favicon at runtime (in CMD)
CMD ["/bin/sh", "-c", "npx gulp generate-favicon && npx gulp && pm2-runtime start ecosystem.config.js"]
