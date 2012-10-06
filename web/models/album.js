var shortid = require('shortid');

var album_prefix = "a_"
  , content_prefix = "c_"
  , default_name = "New Album";
exports.Album = {
  create: function (name, meta) {
    var aid = album_prefix + shortid.generate();
    // TODO: check for aid collisions?
    redis.set(aid, JSON.stringify({
      name: name || default_name,
      metadata: meta,
      users: [],
      queue: []
    }));
    return aid;
  },

  // receive_content -> handleEvent -> pushContent
  pushContent: function (aid, content, res) {
    var cid = content_prefix + shortid.generate();
    // TODO: verify content payload

    // Create new content entry
    redis.set(cid, JSON.stringify(content));

    // Update queue for album
    redis.get(aid, function (err, reply) {
      if (err) { console.log(err); return; }
      if (!reply) {
        // album doesn't exist
        // delete content
        redis.del(cid);
        res.send(sc.NOT_FOUND);
        return;
      }
      var album = JSON.parse(reply);
      if (_.isArray(album.queue)) {
        // THIS IS WHERE WE WANT TO BE
        album.queue.push(cid);
        redis.set(aid, JSON.stringify(album));
        console.log('Added content ' + cid + ' to album ' + aid);
        res.send(sc.OK);
      } else {
        console.log('Invalid album ' + aid);
      }
    });
  }
}
