
/**
 * GET /room/:id
 */
exports.view_room = function (req, res) {
  res.render('index', { title: 'Room' });
};

/**
 * GET /room/create
 */
exports.create_room = function (req, res) {
  res.render('index', { title: 'Room' });
};

