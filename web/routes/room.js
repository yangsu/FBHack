
/**
 * GET /room/:id
 */
exports.view_room = function (req, res) {
  res.render('index', { title: 'Room' });
};

/**
 * POST /room/:id
 */
exports.push_content = function (req, res) {
  res.send(200);
};

/**
 * GET /room/create
 */
exports.create_room = function (req, res) {
  res.render('index', { title: 'Room' });
};

