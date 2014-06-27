$('#form-settings').submit ( event ) ->
	event.preventDefault()
	chrome.storage.sync.set
		'requestInterval': parseInt $( "#request-interval" ).val(), 10
		'requestURL': $( "#request-url" ).val()
		'popupButtonURL': $( "#popup-button-url" ).val()
		'enableNotifications': $( "#enable-notifications" ).prop( "checked" )
		'notificationTitle': $( "#notification-title" ).val()
	, ->
		$( "#settings-saved" ).html "The settings have been saved."
		return
	return

$( document ).ready ->
	chrome.storage.sync.get
		'requestInterval': 1
		'requestURL': 'http://localhost:3000/'
		'popupButtonURL': 'https://www.google.de/'
		'enableNotifications': true
		'notificationTitle': 'New Notification!'
	, ( options ) ->
		$( '#request-interval' ).val options.requestInterval
		$( '#request-url' ).val options.requestURL
		$( '#popup-button-url' ).val options.popupButtonURL
		$( '#enable-notifications' ).prop( 'checked', options.enableNotifications )
		$( "#notification-title" ).val options.notificationTitle
		return
	return
