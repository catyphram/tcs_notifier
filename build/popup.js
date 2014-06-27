(function() {
  var Popup, popup,
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
        'extensionTitle': 'TCS Notifier'
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
        'popupButtonURL': 'https://www.google.de/'
      }, (function(_this) {
        return function(options) {
          var _content;
          _content = {
            "data": _this.bp.getData(),
            "buttonURL": options.popupButtonURL
          };
          console.log(_content);
          $("#content").html(Handlebars.templates.popup(_content));
        };
      })(this));
    };

    return Popup;

  })();

  popup = new Popup();

}).call(this);
