App.Views.NewSong = Backbone.extend({
	events: {
		"submit form" : "save"
	},
	
	initalize: function(){
		this.render();
	},
	
	save: function(){
		var self = this;
		var msg = this.model.isNew() ? 'Successfully created!' : 'Saved!';
		
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
		var out = '<form>';
		out += "<input type='text' class='url_input' placeholder='Song URL'/>";
		
		out += '<input class="submit_input" type="submit" value="Search">';
		out += '</form>';
		
		$(this.el).html(out);
		$('.contents').html(this.el);
	}
});