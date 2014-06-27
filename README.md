tcs_notifier
============

A simple chrome extension that notifies you about ...? ( Depends on you ;) )  
The extension will send a request every x minutes to a specified URL and will pass the response data (array of objects) to a Handlebars Template which you can modify for your purposes.

## Specification

It's an extension for the **Browser Google Chrome**.  
Don't even try running this extension in Firefox, it won't work! (Well, i guess, you can't even load it.)


## Installation

### 1. Get the Extension from github

	git clone https://github.com/catyphram/tcs_notifier
	
### 2. Better make a copy of the folder since you may modify the files (especially the template)

	cp -avR tcs_notifier copy_of_tcs_notifier
	
### 3. And change into the directory

	cd copy_of_tcs_notifier

### 4. Install the depencencies via npm

	npm install
	
### 5. Modify the template (optional)

The enclosed template example expects an array of `{ title: '', date: '', subscriber: 0 }` objects.  
Since your api node may most likely response with different objects you need to modify the template to display the desired attributes. See [here](#template) for further instructions.

### 6. Rebuild the source files (optional)

If you modified any source files ( all files that are in `src/` ) you need to rebuild the `build` folder. See [here](#build).

### 7. Load the extension into Google Chrome

* Type `chrome://extensions/` into your Google Chrome browser
* Check the `developer mode` checkbox
* `load unpacked extension` and select `copy_of_tcs_notifier/build`

### 8. Celebrate!


## <a name="template"></a>Template

To define which data should be displayed in the popup (The window that open when you click the icon.) you need to modify the Handlebars template `src/popup.hbs` The response of the requested api node will be passed to the template, so you can define which data to be displayed.

The whole object passed to the template:

```
{
	data: {
		items: [] # The response from the api node
	},
	buttonURL: '' # The URL the button will lead to
}
```

Visit `http://handlebarsjs.com/` for the Handlebars Syntax.

Don't forget to rebuild the extension!!


## <a name="build"></a>Build

If you manually change the source files ( everything in `src/` ) you need to rebuild the `build` folder. Gulp will do this work for us.

You can either install gulp global (if not already installed) via 
	
	npm install -g gulp

or use the local version already downloaded with the `npm install` before.

Run global version:

	`gulp`

Run local version:

	`./node_modules/.bin/gulp`
	
	
## API Node Response

The api node defined via the exstension setting 'Request URL' will be requested with an empty GET request.

Example Requeset:

	GET host:port/your/node/
	
The API needs to respond with an array of objects (pure JSON, not stringified). The attributes of the objects are not defined and can be handled in the [Popup-Template](#template). If there are no objects available, please respond with an empty array.

Example Response Array (directly passed to the template) :

```
[
	{ title: 'First Object Title', 'count': 5 },
	{ title: 'Sedond Object Title', 'count': 7 },
	...
]
```


## Extension Settings

* Request Interval  
The time in minutes the extension will request the data from the specified URL.
* Request URL  
URL to the api node that will return an array of objects.
* Popup Button URL  
URL that will open in a new window when clicked on the Button in the Popup-Window.
* Enable Notifications  
Whether to display a desktop notification or not when new data is available.

