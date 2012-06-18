describe("RepoRouter routes", function() {

  describe('navigation', function() {
    it('should call index when navigating to a blank hash', function() {
      spyOn(RepoRouter.prototype, 'index');  
      var router = new RepoRouter;
      Backbone.history.start();
      router.navigate('', true);
      expect(RepoRouter.prototype.index).toHaveBeenCalled();
    });
  });
});

describe('Commits', function() {
  it('should be exist', function() {
  });
})
