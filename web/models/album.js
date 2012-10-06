var shortid = require('shortid');

var prefix = "a_"
  , defaultName = "New Album"
  , retrieveLimit = 20;

function generateAID () {
  return prefix + shortid.generate();
}

exports.Album = {
  getPrefix: function () { return prefix; },

  create: function (name, meta) {
    var aid = generateAID()
      , albumName = (name && _.isString(name)) ? name : defaultName;
    // TODO: check for aid collisions?
    redis.set(aid, JSON.stringify({
      name: albumName,
      metadata: meta,
      users: [],
      queue: []
    }));
    return aid;
  },

  enqueue: function (aid, cid, cb) {
    // Update queue for album
    redis.get(aid, function (err, reply) {
      if (err) { cb(err); return; }
      if (!reply) {
        // album doesn't exist
        // delete content
        redis.del(cid);
        cb('Could not find album.');
        return;
      }
      var album = JSON.parse(reply);
      if (_.isArray(album.queue)) {
        // This means success
        album.queue.push(cid);
        redis.set(aid, JSON.stringify(album));
        console.log('Added content ' + cid + ' to album ' + aid);
        cb(null);
      } else {
        console.log('Invalid album ' + aid);
        cb('Album structure invalid.');
      }
    });
  },

  getContents: function (aid, cursor, cb) {
    redis.get(aid, function (err, reply) {
      if (err) { cb(err); return; }
      var album = JSON.parse(reply);
      if (_.isArray(album.queue)) {
        var start = (cursor) ? album.queue.indexOf(cursor) : 0
          , end = start + retrieveLimit;
        redis.mget(album.queue.slice(start, end), function (err, images) {
          var contents = _.zip(album.queue.slice(start, end), images)
            .map(function (c) {
              return {
                cid: c[0],
                payload: JSON.parse(c[1])
              };
            });
          cb(err, contents);
        });
      } else {
        console.log('Invalid album ' + aid);
        cb('Album structure invalid.');
      }
    });
  }
}
