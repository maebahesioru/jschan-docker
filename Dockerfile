FROM node:22-bookworm

RUN apt-get update -y && apt-get install -y \
    ffmpeg imagemagick graphicsmagick git \
    build-essential python3 \
    && rm -rf /var/lib/apt/lists/*

# Clone JSChan to a temp directory, then move to /opt
RUN git clone --depth 1 https://github.com/fatchan/jschan.git /tmp/jschan-src \
    && cp -a /tmp/jschan-src/. /opt/ \
    && rm -rf /tmp/jschan-src

WORKDIR /opt

# Install dependencies
RUN npm install --prefer-offline --no-audit --no-fund

RUN npm install -g pm2 gulp

# Generate secrets.js with env var support (no COPY needed - Coolify build context is Dockerfile-only)
RUN mkdir -p /opt/configs && cat > /opt/configs/secrets.js << 'SECRETS_EOF'
module.exports = {
	dbURL: `mongodb://${process.env.MONGO_USERNAME || 'jschan'}:${process.env.MONGO_PASSWORD || 'changeme'}@${process.env.MONGO_HOST || 'mongodb'}:27017`,
	dbName: 'jschan',
	redis: {
		host: process.env.REDIS_HOST || 'redis',
		port: '6379',
		password: process.env.REDIS_PASSWORD || 'changeme',
	},
	port: 7000,
	cookieSecret: process.env.COOKIE_SECRET || 'changeme',
	tripcodeSecret: process.env.TRIPCODE_SECRET || 'changeme',
	ipHashSecret: process.env.IP_HASH_SECRET || 'changeme',
	postPasswordSecret: process.env.POST_PASSWORD_SECRET || 'changeme',
	google: {
		siteKey: process.env.GOOGLE_SITEKEY || 'changeme',
		secretKey: process.env.GOOGLE_SECRETKEY || 'changeme',
	},
	hcaptcha: {
		siteKey: process.env.HCAPTCHA_SITEKEY || '10000000-ffff-ffff-ffff-000000000001',
		secretKey: process.env.HCAPTCHA_SECRETKEY || '0x0000000000000000000000000000000000000000',
	},
	yandex: {
		siteKey: process.env.YANDEX_CAPTCHA_SITEKEY || 'changeme',
		secretKey: process.env.YANDEX_CAPTCHA_SECRETKEY || 'changeme',
	},
	debugLogs: true,
};
SECRETS_EOF

ENV MONGO_USERNAME=jschan
ENV MONGO_PASSWORD=changeme
ENV REDIS_PASSWORD=changeme
ENV MONGO_HOST=mongodb
ENV REDIS_HOST=redis
ENV NO_CAPTCHA=1
ENV NODE_ENV=production

EXPOSE 7000

CMD ["/bin/sh", "-c", "npx gulp generate-favicon && npx gulp && pm2-runtime start ecosystem.config.js"]
