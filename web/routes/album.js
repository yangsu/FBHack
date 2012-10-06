
/**
 * GET /album/:id
 */
exports.view_album = function (req, res) {
  var aid = req.params.id;
  // temporary album view for testing
  redis.get(aid, function (err, reply) {
    var album = JSON.parse(reply);
    if (album && album.queue && _.isArray(album.queue)) {
      redis.mget(album.queue, function (err, images) {
        var links = (images) ? _(images).map(function (img) {
          return JSON.parse(img).link;
        }) : [];
        res.render('album', { aid: aid, title: album.name, photos: links });
      });
    } else {
      res.send(sc.INTERNAL_SERVER_ERROR);
    }
  });
};

/**
 * POST /api/album/:id
 * body of request should be json as:
 * {
 *  type: "EVENT_TYPE",
 *  payload: { ... }
 * }
 */
exports.receive_content = function (req, res) {
  var event = req.body;
  // Check for existence and validity of payload
  if (contentReceiver.validateEvent(event)) {
    // Add album id
    event.aid = req.params.id;
    contentReceiver.handleEvent(event, res);
    // If handleEvent does not send response, then something bad happened
    //res.send(sc.INTERNAL_SERVER_ERROR);
  } else {
    res.send(sc.BAD_REQUEST);
  }
};

/**
 * GET /album/create
 * Shows view for creating album
 */
exports.create_album_view = function (req, res) {
  res.render('index', { title: 'Room' });
};

/**
 * POST /api/album/create
 * Actually creates a album on the backend
 */
exports.create_album = function (req, res) {
  var aid = Model.Album.create(req.body.name);
  if (aid) {
    res.send(sc.OK, {
      aid: aid
    });
  }
  res.send(sc.INTERNAL_SERVER_ERROR);
};


/**
 * GET /api/album/:id
 * GET /api/album/:id/:cursor
 */
exports.get_album_content = function (req, res) {
  var aid = req.params.id
    , cursor = req.params.cursor;
  Model.Album.getContents(aid, cursor, function (err, contents) {
    if (err) {
      console.log(err);
      /*res.send(sc.BAD_REQUEST, err);
      return;*/
    }
    res.json(contents);
  });
}

