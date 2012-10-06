
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')  // Load index.js route
  , http = require('http')
  , fs = require('fs');

/**
 * Globals
 */
_ = require('underscore');
app = express();
contentReceiver = require('./services/receiver');
sc = require('./lib/statuscode');
// Set up redis
redis = require('redis').createClient(
  process.env.FBHACK_REDIS_PORT || 6379,
  process.env.FBHACK_REDIS_HOST || '127.0.0.1'
);
redis.on('error', function (err) {
  console.log('Redis error: ' + err);
});

app.configure(function(){
  app.set('port', process.env.FBHACK_PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/app'));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

// Utility function for loading the js files in a directory
var loadDirectory = function (dir) {
  return _.chain(fs.readdirSync(dir + '/'))
    .filter(function (file) {
      return (/^[\w\-\.]+\.js$/).test(file);
    })
    .reduce(function (memo, file) {
      console.log('Loading ' + dir + '/' + file);
      var newRoute = require('./' + dir + '/' + file.slice(0, -3));
      return _.extend(memo, newRoute);
    }, {})
    .value();
};

/**
 * Models
 */
Model = loadDirectory('models');

/**
 * Routes
 */
var routes = loadDirectory('routes');

// homepage
app.get('/', routes.index);

// API
app.post('/api/album/create', routes.create_album);
app.post('/api/album/:id', routes.receive_content);
app.get('/api/album/:id', routes.get_album_content);
app.get('/api/album/:id/:cursor', routes.get_album_content);

// Web app routes
app.get('/album/create', routes.create_album_view);
app.get('/album/:id', routes.view_album);
app.get('/qr/:str', routes.qr_encode);
app.get('/:id', routes.view_album); // catch all

/**
 * Start Server
 */
var server = http.createServer(app),
  io = require('socket.io').listen(server);

server.listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
