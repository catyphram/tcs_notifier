class Settings

	constructor: ->
		@initialize()
		return

	initialize: =>

		chrome.storage.sync.get
			'extensionTitle': 'TCS Notifier'
		, ( options ) =>
			document.title = "#{options.extensionTitle} Settings"
			@docTitle = options.extensionTitle
			# double since race condition, not ready yet? set them later
			if @docTitle?
				$( "#settings-header" ).html( "#{@docTitle} <small>Settings</small>" )
				$( "#extension-title" ).val @docTitle
			return

		$('#form-settings').submit ( event ) ->
			event.preventDefault()
			_extTitle = $( "#extension-title" ).val()
			chrome.storage.sync.set
				'extensionTitle': _extTitle
				'requestInterval': parseInt $( "#request-interval" ).val(), 10
				'requestURL': $( "#request-url" ).val()
				'popupButtonURL': $( "#popup-button-url" ).val()
				'enableNotifications': $( "#enable-notifications" ).prop( "checked" )
				'notificationTitle': $( "#notification-title" ).val()
			, ->
				$( "#settings-saved" ).html "The settings have been saved."
				return

			document.title = "#{_extTitle} Settings"
			$( "#settings-header" ).html( "#{_extTitle} <small>Settings</small>" )

			chrome.browserAction.setTitle { 'title': _extTitle }
			return

		$( document ).ready =>
			
			if @docTitle?
				$( "#settings-header" ).html( "#{@docTitle} <small>Settings</small>" )

			chrome.storage.sync.get
				'requestInterval': 1
				'requestURL': 'http://localhost:3000/'
				'popupButtonURL': 'https://www.google.de/'
				'enableNotifications': true
				'notificationTitle': 'New Notification!'
			, ( options ) =>
				$( '#request-interval' ).val options.requestInterval
				$( '#request-url' ).val options.requestURL
				$( '#popup-button-url' ).val options.popupButtonURL
				$( '#enable-notifications' ).prop( 'checked', options.enableNotifications )
				$( "#notification-title" ).val options.notificationTitle

				if @docTitle?
					$( "#extension-title" ).val @docTitle

				return
			return

settings = new Settings()