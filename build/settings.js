(function() {
  var Settings, settings,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Settings = (function() {
    function Settings() {
      this.initialize = __bind(this.initialize, this);
      this.initialize();
      return;
    }

    Settings.prototype.initialize = function() {
      chrome.storage.sync.get({
        'extensionTitle': 'TCS Notifier'
      }, (function(_this) {
        return function(options) {
          document.title = "" + options.extensionTitle + " Settings";
          _this.docTitle = options.extensionTitle;
          if (_this.docTitle != null) {
            $("#settings-header").html("" + _this.docTitle + " <small>Settings</small>");
            $("#extension-title").val(_this.docTitle);
          }
        };
      })(this));
      $('#form-settings').submit(function(event) {
        var _extTitle;
        event.preventDefault();
        _extTitle = $("#extension-title").val();
        chrome.storage.sync.set({
          'extensionTitle': _extTitle,
          'requestInterval': parseInt($("#request-interval").val(), 10),
          'requestURL': $("#request-url").val(),
          'popupButtonURL': $("#popup-button-url").val(),
          'enableNotifications': $("#enable-notifications").prop("checked"),
          'notificationTitle': $("#notification-title").val()
        }, function() {
          $("#settings-saved").html("The settings have been saved.");
        });
        document.title = "" + _extTitle + " Settings";
        $("#settings-header").html("" + _extTitle + " <small>Settings</small>");
        chrome.browserAction.setTitle({
          'title': _extTitle
        });
      });
      return $(document).ready((function(_this) {
        return function() {
          if (_this.docTitle != null) {
            $("#settings-header").html("" + _this.docTitle + " <small>Settings</small>");
          }
          chrome.storage.sync.get({
            'requestInterval': 1,
            'requestURL': 'http://localhost:3000/',
            'popupButtonURL': 'https://www.google.de/',
            'enableNotifications': true,
            'notificationTitle': 'New Notification!'
          }, function(options) {
            $('#request-interval').val(options.requestInterval);
            $('#request-url').val(options.requestURL);
            $('#popup-button-url').val(options.popupButtonURL);
            $('#enable-notifications').prop('checked', options.enableNotifications);
            $("#notification-title").val(options.notificationTitle);
            if (_this.docTitle != null) {
              $("#extension-title").val(_this.docTitle);
            }
          });
        };
      })(this));
    };

    return Settings;

  })();

  settings = new Settings();

}).call(this);
