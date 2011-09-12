App.Controllers.Songs = Backbone.Controller.extend({
	routes: {
		"/:id":	"show",
		"": "index"
	}
});