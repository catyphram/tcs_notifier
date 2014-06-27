class Popup

	constructor: ->

		@initialize()
		return

	initialize: =>

		chrome.storage.sync.get
			'extensionTitle': if _settings.extensionTitle? then _settings.extensionTitle else ""
		, ( options ) ->
			document.title = options.extensionTitle
			return
			
		chrome.runtime.getBackgroundPage ( @bp ) =>

			$( document ).ready =>
				@render()
				return
			return
		return

	render: =>

		chrome.storage.sync.get
			'popupButtonURL': if _settings.popupButtonURL? then _settings.popupButtonURL else ""
		, ( options ) =>

			_content =
				"data": @bp.getData()
				"buttonURL": _settings.popupButtonURL

			$( "#content" ).html Handlebars.templates.popup _content

			return
		return


_settings = {}

$.getJSON './settings.json'
	.done ( data ) ->
		_settings = data
		return
	.always ->
		popup = new Popup()
		return
