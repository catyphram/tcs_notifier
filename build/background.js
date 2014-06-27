(function() {
  var Background, _settings,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Background = (function() {
    function Background() {
      this.updateData = __bind(this.updateData, this);
      this.initialize = __bind(this.initialize, this);
      this.initialize();
      return;
    }

    Background.prototype.initialize = function() {
      this.data = {
        "items": []
      };
      chrome.storage.sync.get({
        'requestInterval': _settings.requestInterval != null ? _settings.requestInterval : 1,
        'extensionTitle': _settings.extensionTitle != null ? _settings.extensionTitle : ""
      }, function(options) {
        chrome.browserAction.setTitle({
          'title': options.extensionTitle
        });
        chrome.alarms.create({
          "periodInMinutes": options.requestInterval
        });
        chrome.alarms.onAlarm.addListener(this.updateData);
      });
      chrome.alarms.onAlarm.addListener(this.updateData);
      chrome.storage.onChanged.addListener((function(_this) {
        return function(changes, areaName) {
          if (changes.requestInterval != null) {
            chrome.alarms.create({
              "periodInMinutes": changes.requestInterval.newValue
            });
            _this.updateData();
          }
        };
      })(this));
      this.updateData();
    };

    Background.prototype.renderBadgeOk = function(text) {
      chrome.browserAction.setBadgeBackgroundColor({
        "color": "#000080"
      });
      chrome.browserAction.setBadgeText({
        "text": text
      });
    };

    Background.prototype.renderBadgeFail = function() {
      chrome.browserAction.setBadgeBackgroundColor({
        "color": "#FF0000"
      });
      chrome.browserAction.setBadgeText({
        "text": ":("
      });
    };

    Background.prototype.updateData = function() {
      var _notificationItems;
      _notificationItems = [];
      chrome.storage.sync.get({
        'requestURL': _settings.requestURL != null ? _settings.requestURL : "",
        'enableNotifications': _settings.enableNotifications != null ? _settings.enableNotifications : true,
        'notificationTitle': _settings.notificationTitle != null ? _settings.notificationTitle : ""
      }, (function(_this) {
        return function(options) {
          $.get(options.requestURL, function(data, textstatus, jqXHR) {
            var _found, _i, _j, _len, _len1, _newEntry, _oldEntry, _popups, _ref;
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              _newEntry = data[_i];
              _found = false;
              _ref = _this.data.items;
              for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
                _oldEntry = _ref[_j];
                if (_oldEntry.title === _newEntry.title) {
                  _found = true;
                  break;
                }
              }
              if (!_found) {
                _notificationItems.push({
                  "title": _newEntry.title,
                  "message": ""
                });
              }
            }
            if (options.enableNotifications) {
              chrome.notifications.create("", {
                "type": "list",
                "title": options.notificationTitle,
                "message": "",
                "iconUrl": "./resources/images/browser_icon.png",
                "items": _notificationItems
              }, function() {});
            }
            if (data.length === 0) {
              _this.renderBadgeOk("");
            } else if (data.length > 999) {
              _this.renderBadgeOk(">999");
            } else {
              _this.renderBadgeOk(data.length.toString());
            }
            _this.data.items = data;
            _popups = chrome.extension.getViews({
              "type": "popup"
            });
            if (_popups.length > 0) {
              popups[0].popup.render();
            }
          }).fail(function(jqXHR, textStatus, errorThrown) {
            _this.renderBadgeFail();
          });
        };
      })(this));
    };

    return Background;

  })();

  _settings = {};

  $.getJSON('./settings.json').done(function(data) {
    _settings = data;
  }).always((function(_this) {
    return function() {
      var background;
      background = new Background();
      _this.getData = function() {
        return background.data;
      };
    };
  })(this));

}).call(this);
