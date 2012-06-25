$(function() {
  var playback, prev;

  $.get('/commits.json', function(data) {
    success: {
      playback = new DiffPlayback(data);
      $('.slider').attr('max', playback.commits.length, 'min', 0)
      playback.init();
    }
  });

  $('.slider').change(function(e) {
    e.preventDefault(); 
    playback.drawCommit(this.value);
  });

});
