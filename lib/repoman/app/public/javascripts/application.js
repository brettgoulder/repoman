$(function() {
  var playback, prev;

  $.get('/commits.json', function(data) {
    success: {
      playback = new DiffPlayback(data);
      $('.slider').attr('max', playback.commits.length, 'min', 0)
      playback.init();
    }
  });

  $('.forward').click(function(e) {
    e.preventDefault();
    playback.drawForward();
  });

  $('.reverse').click(function(e) {
    e.preventDefault();
    playback.drawReverse();
  });

  $('.slider').change(function(e) {
    e.preventDefault(); 
    if(this.value > prev) {
      playback.drawForward(this.value - 1);
      prev = this.value;
    } else
      playback.drawReverse(this.value - 1);
      prev = this.value;
  });

});
