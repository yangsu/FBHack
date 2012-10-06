
/**
 * GET /qr/:string
 * :string is string to encode
 */
exports.qr_encode = function (req, res) {
  var aid = req.params.str;
  if (aid &&
      _.isString(aid) &&
      aid.match(/[0-9A-Za-z_-]{7,12}/)) {
    Model.Album.get(aid, function (err, album) {
      if (err) { res.send(sc.INTERNAL_SERVER_ERROR, err); return; }
      if (!album) { res.send(sc.NOT_FOUND); return; }
      var strToEncode = aid + ':' + album.name;
      var Encoder = require('qr').Encoder
        , encoder = new Encoder();
        encoder.on('end', function (png) {
          res.set('Content-Type', 'image/png');
          res.send(png);
        });
        encoder.encode(strToEncode, null, {
          dot_size: 16
        });
      });
  } else {
    res.send(sc.BAD_REQUEST);
  }
};

