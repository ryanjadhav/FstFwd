var App = {
	Views: {},
	Controllers: {},
	init: function() {
		console.log('App Start');
		new App.Controllers.Songs();
		Backbone.history.start();
	}
};