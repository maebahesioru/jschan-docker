module.exports = {

	//mongodb connection string
	dbURL: `mongodb://${process.env.MONGO_USERNAME || 'jschan'}:${process.env.MONGO_PASSWORD || 'changeme'}@${process.env.MONGO_HOST || 'mongodb'}:27017`,

	//database name
	dbName: 'jschan',

	//redis connection info
	redis: {
		host: process.env.REDIS_HOST || 'redis',
		port: '6379',
		password: process.env.REDIS_PASSWORD || 'changeme',
	},

	//backend webserver port
	port: 7000,

	//secrets/salts for various things
	cookieSecret: process.env.COOKIE_SECRET || 'changeme',
	tripcodeSecret: process.env.TRIPCODE_SECRET || 'changeme',
	ipHashSecret: process.env.IP_HASH_SECRET || 'changeme',
	postPasswordSecret: process.env.POST_PASSWORD_SECRET || 'changeme',

	//keys for google recaptcha
	google: {
		siteKey: process.env.GOOGLE_SITEKEY || 'changeme',
		secretKey: process.env.GOOGLE_SECRETKEY || 'changeme',
	},

	//keys for hcaptcha
	hcaptcha: {
		siteKey: process.env.HCAPTCHA_SITEKEY || '10000000-ffff-ffff-ffff-000000000001',
		secretKey: process.env.HCAPTCHA_SECRETKEY || '0x0000000000000000000000000000000000000000',
	},

	//keys for yandex smartcaptcha
	yandex: {
		siteKey: process.env.YANDEX_CAPTCHA_SITEKEY || 'changeme',
		secretKey: process.env.YANDEX_CAPTCHA_SECRETKEY || 'changeme',
	},

	//enable debug logging
	debugLogs: true,

};
