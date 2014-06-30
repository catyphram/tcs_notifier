class Settings

	constructor: ->
		@initialize()
		return

	initialize: =>

		chrome.storage.sync.get
			'extensionTitle': if _settings.extensionTitle? then _settings.extensionTitle else ""
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
			_browsserButtonAction = $( 'input:radio[name=browser-button-action-radio]:checked' ).val()

			console.log _browsserButtonAction
			if not _browsserButtonAction?
				_browsserButtonAction = _settings.browserButtonAction

			chrome.storage.sync.set
				'extensionTitle': _extTitle
				'requestInterval': parseInt $( "#request-interval" ).val(), 10
				'requestURL': $( "#request-url" ).val()
				'browserButtonAction': _browsserButtonAction
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
				'requestInterval': if _settings.requestInterval? then _settings.requestInterval else 1
				'requestURL': if _settings.requestURL? then _settings.requestURL else ""
				'popupButtonURL': if _settings.popupButtonURL? then _settings.popupButtonURL else ""
				'browserButtonAction': if _settings.browserButtonAction? then _settings.browserButtonAction else "openPopup"
				'enableNotifications': if _settings.enableNotifications? then _settings.enableNotifications else true
				'notificationTitle': if _settings.notificationTitle? then _settings.notificationTitle else ""
			, ( options ) =>
				$( '#request-interval' ).val options.requestInterval
				$( '#request-url' ).val options.requestURL
				$( '#popup-button-url' ).val options.popupButtonURL
				$( "#browser-button-action-#{options.browserButtonAction}" ).prop 'checked', true
				$( '#enable-notifications' ).prop 'checked', options.enableNotifications
				$( '#notification-title' ).val options.notificationTitle
				if @docTitle?
					$( '#extension-title' ).val @docTitle

				return
			return


_settings = {}

$.getJSON './settings.json'
	.done ( data ) ->
		_settings = data
		return
	.always ->
		settings = new Settings()
		return
