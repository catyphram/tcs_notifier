(function() {
  var Popup, _settings,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Popup = (function() {
    function Popup() {
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      this.initialize();
      return;
    }

    Popup.prototype.initialize = function() {
      chrome.storage.sync.get({
        'extensionTitle': _settings.extensionTitle != null ? _settings.extensionTitle : ""
      }, function(options) {
        document.title = options.extensionTitle;
      });
      chrome.runtime.getBackgroundPage((function(_this) {
        return function(bp) {
          _this.bp = bp;
          $(document).ready(function() {
            _this.render();
          });
        };
      })(this));
    };

    Popup.prototype.render = function() {
      chrome.storage.sync.get({
        'popupButtonURL': _settings.popupButtonURL != null ? _settings.popupButtonURL : ""
      }, (function(_this) {
        return function(options) {
          var _content;
          _content = {
            "data": _this.bp.getData(),
            "buttonURL": _settings.popupButtonURL
          };
          $("#content").html(Handlebars.templates.popup(_content));
        };
      })(this));
    };

    return Popup;

  })();

  _settings = {};

  $.getJSON('./settings.json').done(function(data) {
    _settings = data;
  }).always(function() {
    var popup;
    popup = new Popup();
  });

}).call(this);
