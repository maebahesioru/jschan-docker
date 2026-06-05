FROM node:22-bookworm

RUN apt-get update -y && apt-get install -y ffmpeg imagemagick graphicsmagick git && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Clone JSChan from GitHub
RUN git clone --depth 1 https://github.com/fatchan/jschan.git /opt

# Install dependencies
RUN npm install
RUN npm install -g pm2 gulp

# Use our custom secrets.js with env var support  
COPY secrets.js ./configs/secrets.js

ENV MONGO_USERNAME=jschan
ENV MONGO_PASSWORD=changeme
ENV REDIS_PASSWORD=changeme
ENV MONGO_HOST=mongodb
ENV REDIS_HOST=redis
ENV NO_CAPTCHA=1

# Expose port 7000
EXPOSE 7000

CMD ["/bin/sh", "-c", "npx gulp generate-favicon && npx gulp && pm2-runtime start ecosystem.config.js"]
