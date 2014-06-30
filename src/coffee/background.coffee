class Background

# tutorial
# badge background color option
# test: empty reply, wrong reply
# display empty message if no item available
# loading timer when requesting
# better look for options page
# backgroundpage nearly complete with events, so not complete init every time
# option open link, oder nothing when notif clicked
# async, so settings set before get, and notif wont show even though disabled
# check all race conditions

	constructor: ->

		@initialize()
		return

	initialize: =>

		@_notificationId = "tcs_notifier"

		chrome.storage.sync.get
			'data': { "items": [] }
		, ( storage ) =>
			@data = storage.data
			
			@updateData()
			return

		chrome.storage.sync.get
			'requestInterval': if _settings.requestInterval? then _settings.requestInterval else 1
			'extensionTitle': if _settings.extensionTitle? then _settings.extensionTitle else ""
			'browserButtonAction': if _settings.browserButtonAction? then _settings.browserButtonAction else "openPopup"
		, ( options ) =>
			@enablePopup options.browserButtonAction is "openPopup"
			chrome.browserAction.setTitle { 'title': options.extensionTitle }
			chrome.alarms.create "periodInMinutes": options.requestInterval
			chrome.alarms.onAlarm.addListener( @updateData )
			return			

		chrome.alarms.onAlarm.addListener @updateData

		chrome.storage.onChanged.addListener ( changes, areaName ) =>
			if changes.requestInterval?
				chrome.alarms.create "periodInMinutes": changes.requestInterval.newValue
				@updateData()
			else if changes.browserButtonAction?
				if changes.browserButtonAction.newValue is "openLink"
					@enablePopup false	
				else if changes.browserButtonAction.oldValue is "openLink"
					@enablePopup true

			return

		chrome.notifications.onClicked.addListener ( notificationId ) =>
			if notificationId is @_notificationId
				chrome.storage.sync.get
					'popupButtonURL': if _settings.popupButtonURL? then _settings.popupButtonURL else ""
				, ( options ) ->
					chrome.tabs.create
						url: options.popupButtonURL

					return
			return
		
		chrome.browserAction.onClicked.addListener ->
			chrome.storage.sync.get
				'popupButtonURL': if _settings.popupButtonURL? then _settings.popupButtonURL else ""
			, ( options ) ->
					chrome.tabs.create
						url: options.popupButtonURL

				return
			return
		return

	renderBadgeOk: ( text ) ->

		chrome.browserAction.setBadgeBackgroundColor { "color": "#000080" }
		chrome.browserAction.setBadgeText { "text": text }

		return

	renderBadgeFail: ->

		chrome.browserAction.setBadgeBackgroundColor { "color": "#FF0000" }
		chrome.browserAction.setBadgeText { "text": ":(" }

		return


	updateData: =>

		_notificationItems = []
		# First argument is the receiver and must be an object, error!

		chrome.storage.sync.get
			'requestURL': if _settings.requestURL? then _settings.requestURL else ""
			'enableNotifications': if _settings.enableNotifications? then _settings.enableNotifications else true
			'notificationTitle': if _settings.notificationTitle? then _settings.notificationTitle else ""
		, ( options ) =>

			$.get options.requestURL, ( data, textstatus, jqXHR ) =>

				for _newEntry in data
					_found = false
					for _oldEntry in @data.items
						if _oldEntry.title is _newEntry.title
							_found = true
							break
					if not _found
						_notificationItems.push { "title": _newEntry.title, "message": "" }

				if options.enableNotifications and _notificationItems.length > 0
					chrome.notifications.create @_notificationId,
						"type": "list",
						"title": options.notificationTitle,
						"message": "",
						"iconUrl": "./resources/images/browser_icon.png",
						"items": _notificationItems
					, ->
						return
				
				if data.length is 0
					@renderBadgeOk ""
				else if data.length > 999
					@renderBadgeOk ">999"
				else
					@renderBadgeOk data.length.toString()

				@saveData data

				_popups = chrome.extension.getViews "type": "popup"

				# Is at least one popup open?
				if _popups.length > 0
					# (we only have one though ;) )
					_popups[0].render()

				return
			.fail ( jqXHR, textStatus, errorThrown ) =>
				@renderBadgeFail()
				return
			return
		return

	saveData: ( items ) =>

		@data.items = items

		chrome.storage.sync.set
			'data': @data
		, ->
			return

		return

	enablePopup: ( enabled ) ->

		chrome.browserAction.setPopup
			'popup': if enabled then "popup.html" else ""

		return

_settings = {}

$.getJSON './settings.json'
	.done ( data ) ->
		_settings = data
		return
	.always =>
		background = new Background()
		@getData = ->
			# return
			background.data
		return
