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
      var i, w, h, left, top,
	left1 = 0, left2 = 0,
	lastTopH = 0, lastBotH = 0,
	lastTopW = 0, lastBotW = 0,
	diff = 0, border;
      for (i = 0; i < this.length; i++) {
	  w = this.getRandomDimension();
	  border = '';
	  if (left1 > left2) {
	      border = 'border-t';
	      left = left2;
	      diff = left1 - left2;
	      if (Math.random() >= 0.5 && diff >= 25 && _.contains(this.dimensions, diff)) {
		w = diff;
		left2 = left1;
	      } else {
		left2 += w;
		// border += ' border-r';
	      }
	      top = lastTopH;
	      h = 100 - lastTopH;
	      lastBotH = h;
	      lastBotW = w;
	  } else if (left2 > left1) {
	      left = left1;
	      diff = left2 - left1;
	      if (Math.random() >= 0.5 && diff >= 25 && _.contains(this.dimensions, diff)) {
		w = diff;
		left1 = left2;
	      } else {
		left1 += w;
		// border = ' border-r';
	      }
	      top = 0;
	      h = 100 - lastBotH;
	      lastTopH = h;
	      lastTopW = w;
	  } else {
	      // border = ' border-r';
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
	  this.at(i).set(vals);
	}
    return this;
  }
});
