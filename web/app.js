
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

app.configure(function(){
  app.set('port', process.env.FBHACK_PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

/**
 * Routes
 */

// Load all routes in ./routes/
var routes = _.chain(fs.readdirSync('routes/'))
  .filter(function (file) {
    return (/^[\w\-\.]+\.js$/).test(file);
  })
  .reduce(function (memo, file) {
    console.log('Loading route ' + file);
    var newRoute = require('./routes/' + file.slice(0, -3));
    return _.extend(memo, newRoute);
  }, {})
  .value();

app.get('/', routes.index);
app.get('/room/create', routes.create_room);
app.get('/room/:id', routes.view_room);

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
