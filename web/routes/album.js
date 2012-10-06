
/**
 * GET /album/:id
 */
exports.view_album = function (req, res) {
  res.render('index', { title: 'Room' });
};

/**
 * POST /album/:id
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
 * POST /album
 * Actually creates a album on the backend
 */
exports.create_album = function (req, res) {
  var aid = Model.Album.create();
  if (aid) {
    res.send(sc.OK, {
      aid: aid
    });
  }
  res.send(sc.INTERNAL_SERVER_ERROR);
};

