class Popup

	constructor: ->

		@initialize()

	initialize: =>

		chrome.runtime.getBackgroundPage ( @bp ) =>

			$( document ).ready =>
				@render()
				return
			return
		return

	render: =>

		chrome.storage.sync.get
			'popupButtonURL': 'https://www.google.de/'
		, ( options ) =>

			_content =
				"data": @bp.getData()
				"buttonURL": options.popupButtonURL

			console.log _content
			$( "#content" ).html Handlebars.templates.popup _content

			return
		return

popup = new Popup()