
/**
 * GET /room/:id
 */
exports.view_room = function (req, res) {
  res.render('index', { title: 'Room' });
};

/**
 * POST /room/:id
 * body of request should be json as:
 * {
 *  type: "EVENT_TYPE",
 *  payload: { ... }
 * }
 */
exports.receive_content = function (req, res) {
  var event = req.body;
  console.log(event);
  // Check for existence and validity of payload
  if (contentReceiver.validateEvent(event)) {
    if (contentReceiver.handleEvent(event)) {
      res.send(sc.OK);
    }
    res.send(sc.INTERNAL_SERVER_ERROR);
  }
  res.send(sc.BAD_REQUEST);
};

/**
 * GET /room/create
 */
exports.create_room = function (req, res) {
  res.render('index', { title: 'Room' });
};

