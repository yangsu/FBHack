
/**
 * GET /qr/:string
 * :string is string to encode
 */
exports.qr_encode = function (req, res) {
  var strToEncode = req.params.str;
  if (strToEncode &&
      _.isString(strToEncode) &&
      strToEncode.match(/[A-Za-z_-]{7,12}/)) {
    var Encoder = require('qr').Encoder
      , encoder = new Encoder();
      encoder.on('end', function (png) {
        res.set('Content-Type', 'image/png');
        res.send(png);
      });
      encoder.encode(strToEncode, null, {
        dot_size: 16
      });
  } else {
    res.send(sc.BAD_REQUEST);
  }
};

