var DiffPlayback;

DiffPlayback = (function() {
  var self, commit, new_file = true, infoTemplate, rowTemplate;

  function DiffPlayback(commits) {
    this.commits = commits;
  }

  DiffPlayback.prototype.init = function() {
    commit = 0;
    self = this;
    this.setupTemplates();
    this.drawCommit(commit);
  };

  DiffPlayback.prototype.setupTemplates = function() {
    infoTemplate = Handlebars.compile($('#commit-template').html());
    rowTemplate = Handlebars.compile($('#row-template').html());
  }

  DiffPlayback.prototype.drawCommit = function(value) {
    var that = this;
    commit = value;
    $('.commit-history .info').html(infoTemplate(this.commits[commit]));
    $('tbody').html(rowTemplate(this.commits[commit]));
    $(this.commits[commit].diff_parts).each(function(index, part) {
      that.drawDiffParts(part);
    });
    this.drawLineNumbers();
  }

  DiffPlayback.prototype.drawDiffParts = function(part) {
    $('tbody').data().marker = part.start_line
    console.log(part);
    $(this.commits[commit].diff_parts[0].lines).each(function(index, value) {
      if(value.type === 'unchanged' || value.type === 'add') {
        $('tr:nth-child(' + $('tbody').data('marker') + ')').addClass(value.type);
        $('tbody').data().marker++;
      }
    });
  }

  DiffPlayback.prototype.drawLineNumbers = function() {
    $('tr td:first-child').each(function(index, value) {
      $(value).html(index + 1); 
    });
  }

  return DiffPlayback;
})();

window.DiffPlayback = DiffPlayback;
