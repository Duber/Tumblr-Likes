var connect = require('connect');
var serveStatic = require('serve-static');
var tumblr = require('tumblr');
connect().use(serveStatic(__dirname)).listen(8080);
