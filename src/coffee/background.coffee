class Background

# switch to event page
# options.json
# tutorial
# badge background color option
# test: empty reply, wrong reply, options wrong/empty?
# notification link -> homepage, option click on action button -> homepage
	constructor: ->

		@initialize()
		return

	initialize: =>

		@data = { "items": [] }

		chrome.storage.sync.get
			'requestInterval': if _settings.requestInterval? then _settings.requestInterval else 1
			'extensionTitle': if _settings.extensionTitle? then _settings.extensionTitle else ""
		, ( options ) ->
			chrome.browserAction.setTitle { 'title': options.extensionTitle }
			chrome.alarms.create "periodInMinutes": options.requestInterval
			chrome.alarms.onAlarm.addListener( @updateData )
			return

		chrome.alarms.onAlarm.addListener @updateData

		chrome.storage.onChanged.addListener ( changes, areaName ) =>
			if changes.requestInterval?
				chrome.alarms.create "periodInMinutes": changes.requestInterval.newValue
				@updateData()
			return

		@updateData()

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

				if options.enableNotifications
					chrome.notifications.create "",
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

				@data.items = data

				_popups = chrome.extension.getViews "type": "popup"

				# Is at least one popup open
				if _popups.length > 0
					# (we only have one though ;) )
					popups[0].popup.render()

				return
			.fail ( jqXHR, textStatus, errorThrown ) =>
				@renderBadgeFail()
				return
			return
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
