
window.FBHack = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  Templates: {},
  init: function() {
    this.router = new FBHack.Routers.ApplicationRouter();

    // Trigger the initial route and enable HTML5 History API support, set the
    // root folder to '/' by default.  Change in app.js.
    Backbone.history.start({ pushState: false, root: '/' });

    // All navigation that is relative should be passed through the navigate
    // method, to be processed by the router. If the link has a `data-bypass`
    // attribute, bypass the delegation completely.
    // $(document).on("click", "a:not([data-bypass])", function(evt) {
    //   // Get the absolute anchor href.
    //   var href = $(this).attr("href");

    //   // If the href exists and is a hash route, run it through Backbone.
    //   if (href && href.indexOf("#") === 0) {
    //     // Stop the default event to ensure the link will not cause a page
    //     // refresh.
    //     evt.preventDefault();

    //     // `Backbone.history.navigate` is sufficient for all Routers and will
    //     // trigger the correct events. The Router's internal `navigate` method
    //     // calls this anyways.  The fragment is sliced from the root.
	// Backbone.history.navigate(href, true);
    //   }
    // });
  },
  getTemplate: function (templateName) {
    var path = 'scripts/templates/' + templateName + ".html";

    if (!FBHack.Templates[path]) {
      $.ajax({ url: path, async: false }).then(function(contents) {
	FBHack.Templates[path] = _.template(contents);
      });
    }

    return FBHack.Templates[path];
  }
};

$(document).ready(function(){
  $('#main').css('height', $(window).height() + 'px');
  FBHack.init();
});
