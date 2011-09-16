App.Views.NewSong = Backbone.View.extend({
	events: {
		"submit form" : "save"
	},
	
	initialize: function(){
		console.log('Init NewSong');
		this.render();
	},
	
	save: function(){
		var self = this;
		var msg = 'Successfully created!';
		
		this.model.save({ orig_url: this.$('.url_input').val() }, {
			success: function(model, resp){
				new App.Views.Notice({ message: msg});
				
				self.model = model;
				self.render();
				self.delegateEvents();
				
				Backbone.history.saveLocation('/' + model.id);
			},
			error: function(){
				new App.Views.Error();
			}
		});
		
		return false;
	},
	
	render: function(){
		this.el = document.createElement('form');
		
		var out = "<div class='input_url'>";
		out += "<input type='text' class='url_input' placeholder='Song URL'/>";
		out += '<input class="submit_input" type="submit" value="Search">';
		out += "</div>";
				
		$(this.el).html(out);
		$('.contents').append(this.el);
	}
});