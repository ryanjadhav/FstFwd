var App = {
	Views: {},
	Controllers: {},
	init: function() {
		new App.Controllers.Songs();
		Backbone.history.start();
	}
};