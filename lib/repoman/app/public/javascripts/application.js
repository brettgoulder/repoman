(function($){
  window.RepoRouter = Backbone.Router.extend({
    routes: {
      '': 'index' 
    },

    index: function() {
    }
  
  });

  window.Commit = Backbone.Model.extend({});

  window.CommitView = Backbone.View.extend({
    initialize: function() {
      this.template = _.template($('#commit-template').html());
    },

    render: function() {
      var RenderedContent = this.template(this.model.toJSON());
      $(this.el).html(RenderedContent);
      return this;
    }
  });
})(jQuery)
