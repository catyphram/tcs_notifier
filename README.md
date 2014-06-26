tcs_notifier
============

A simple chrome extension that notifies you about ...? ( Depends on you ;) )  
The extension will send a request every x minutes to a specified URL and will pass the response data (array of objects) to a Handlebars Template which you can modify for your purposes.


## Installation

	git clone https://github.com/catyphram/tcs_notifier
	cd tcs_notifier
	npm install
	
## Template

To define which data should be displayed in the popup you need to modify the Handlebars template `src/popup.hbs` (and rebuild it!). The response of the requested api node will be passed to the template, so you can define which data to be displayed. The items/response are/is accessible via `data.items`.  
Visit `http://handlebarsjs.com/` for the Handlebars Syntax.
	
## Build

If you manually change the source files (Coffee-Script (\*.coffee) and Handlebars-Template-Files (\*.hbs) ) you need to rebuild and compile the JavaScript and Template files. Gulp will do the work. Just run

	gulp
	
to build/compile the files.

## Load the Extension

* Go to `chrome://extensions/` in your chrome browser  
* Check the `developer mode` checkbox
* `load unpacked extension` and select `tcs_notifier/build`
* Should work now :)

(TODO: Add some screens)

## Options

* Request Interval  
The time in minutes the extension will request the data from the specified URL / Update every x minutes
* Request URL  
URL to the api node that will return an array of objects
* Popup Button URL  
URL that will open in a new window when clicked on the Button in the Popup-Window
* Enable Notifications  
Whether to display a desktop notification when new data is available

