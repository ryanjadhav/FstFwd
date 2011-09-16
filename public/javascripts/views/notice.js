App.Views.Show = Backbone.Views.Extend({
	events: {
		'click .exit': 'close'
	}
	
	initialize: function(){
		this.render();
	},
	
	render: function(){
		//Show this dialog
	},
	
	close: function(){
		//Close this dialog
	}

});