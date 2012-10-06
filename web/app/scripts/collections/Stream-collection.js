FBHack.Collections.StreamCollection = Backbone.Collection.extend({
  model: FBHack.Models.ItemModel,
  initialize: function () {

  },
  // dimensions: [25, 30, 40, 50, 60, 70, 75, 100],
  dimensions: [30, 40, 50, 60, 70, 100],
  getRandomDimension: function () {
      return this.dimensions[Math.floor(Math.random()*this.dimensions.length)]
  },
  computeLayout: function (width, height) {
      var i, img, w, h, left, top,
        left1 = 0, left2 = 0,
        lastTopH = 0, lastBotH = 0,
        lastTopW = 0, lastBotW = 0,
        diff = 0, border, scalar;
      for (i = 0; i < this.length; i++) {
        img = this.at(i);
        d = this.getRandomDimension();
        max = (Math.random() >= 0.5) ? width : height;
        if (img.width >= img.height) {
          scalar = d/100*max/img.width;
          w = d;
          h = img.height * scalar / height * 100;
        }



      for (i = 0; i < this.length; i++) {
          img = this.at(i);
          w = this.getRandomDimension();
          border = '';
          if (left1 > left2) {
              border = 'border-t';
              left = left2;
              diff = left1 - left2;
              if (Math.random() >= 0.5 && diff >= 25) {
                w = diff;
                left2 = left1;
              } else {
                left2 += w;
              }
              top = lastTopH;
              h = 100 - lastTopH;
              lastBotH = h;
              lastBotW = w;
          } else if (left2 > left1) {
              left = left1;
              diff = left2 - left1;
              if (Math.random() >= 0.5 && diff >= 25) {
                w = diff;
                left1 = left2;
              } else {
                left1 += w;
              }
              top = 0;
              h = 100 - lastBotH;
              lastTopH = h;
              lastTopW = w;
          } else {
              left = left1;
              left1 += w;
              top = 0;
              h = this.getRandomDimension();
              lastTopH = h;
              lastTopW = w;
          }
          var vals = {
            w: w,
            h: h,
            l: left,
            t: top,
            border: border
          };
          img.set(vals);
        }
    return this;
  }
});
