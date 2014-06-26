(function() {
  $('#form-settings').submit(function(event) {
    event.preventDefault();
    chrome.storage.sync.set({
      'requestInterval': parseInt($("#request-interval").val(), 10),
      'requestURL': $("#request-url").val(),
      'popupButtonURL': $("#popup-button-url").val(),
      'enableNotifications': $("#enable-notifications").prop("checked")
    }, function() {
      $("#settings-saved").html("The settings have been saved.");
    });
  });

  $(document).ready(function() {
    chrome.storage.sync.get({
      'requestInterval': 1,
      'requestURL': 'http://localhost:3000/',
      'popupButtonURL': 'https://www.google.de/',
      'enableNotifications': true
    }, function(options) {
      $('#request-interval').val(options.requestInterval);
      $('#request-url').val(options.requestURL);
      $('#popup-button-url').val(options.popupButtonURL);
      $('#enable-notifications').prop('checked', options.enableNotifications);
    });
  });

}).call(this);
