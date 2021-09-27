# Titanium BottomSheetController iOS Module (iOS 15+)

<img src="./demo.gif" width="293" height="634" alt="Example" />


## Methods

### `createBottomSheet({properties}) `
### `show({animated:bool}) `
### `hide({animated:bool}) `
### `selectedDetentIdentifier` return STRING - selectedDetentIdentifier (medium,large or none)

## Events

### `opened `
### `closed `
### `dismissing `
### `detentChange ` returns {"selectedDetentIdentifier":"medium",....}


## Properties

### `detents:{large:bool,medium:bool}`
#### The object of heights where a sheet can rest.
*if not set, default to 'medium' only*

### `preferredCornerRadius:integer`
#### The corner radius that the sheet attempts to present with.
*if not set default to iOS default radius*

###	`prefersEdgeAttachedInCompactHeight:bool`
#### A Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class.

### `prefersScrollingExpandsWhenScrolledToEdge:bool`
#### A Boolean value that determines whether scrolling expands the sheet to a larger detent.

### `widthFollowsPreferredContentSizeWhenEdgeAttached:bool`
#### A Boolean value that determines whether the sheet's width matches its view controller's preferred content size.

### `prefersGrabberVisible:bool`
#### A Boolean value that determines whether the sheet shows a grabber at the top.

### `largestUndimmedDetentIdentifier:string`
#### medium or large - if not set, it is full dimmed depending on activated detents - The largest detent that doesn’t dim the view underneath the sheet. 
***If not set, defaults to full dimmed***

### `contentView:TiUIView,TiUIWindow or TiUINavigationWindow`
#### View (any kind), Window or NavigationWindow



## Example

```js

var TiBottomSheetControllerModule = require("ti.bottomsheetcontroller");


var tableRows = [];

var tableData = [ {title: 'Apples'}, {title: 'Bananas'}, {title: 'Carrots'}, {title: 'Potatoes'},{title: 'Apples'}, {title: 'Bananas'}, {title: 'Carrots'}, {title: 'Potatoes'},{title: 'Apples'}, {title: 'Bananas'}, {title: 'Carrots'}, {title: 'Potatoes'},{title: 'Apples'}, {title: 'Bananas'}, {title: 'Carrots'}, {title: 'Potatoes'},{title: 'Apples'}, {title: 'Bananas'}, {title: 'Carrots'}, {title: 'Potatoes'},{title: 'Apples'}, {title: 'Bananas'}, {title: 'Carrots'}, {title: 'Potatoes'},{title: 'Apples'}, {title: 'Bananas'}, {title: 'Carrots'}, {title: 'Potatoes'} ];

for (var j = 0; j < tableData.length; j++) {
			var rowView = Ti.UI.createView({
				top:1,
				bottom:1,
				width:Ti.UI.FILL,
				height:62,
				backgroundColor:'transparent'
			});

			var title = Ti.UI.createLabel({
				color: '#000',
				width:Ti.UI.SIZE,
				height:Ti.UI.SIZE,
				font: {
					fontFamily : 'Arial',
					fontSize: 22,
					fontWeight: 'bold'
				},
				text: tableData[j].title
			});
			rowView.add(title);

			var row = Ti.UI.createTableViewRow({
				className:'test', 
				height:60,
				backgroundColor:'transparent',
				width:Ti.UI.FILL
			});
			row.add(rowView);
			tableRows.push(row);
}


var bottomView = Ti.UI.createTableView({
	top:0,
	left:0,
	right:0,
	bottom:0,
	showVerticalScrollIndicator: true,
	width:Ti.UI.FILL,
	height:500,
	contentHeight:Ti.UI.SIZE,
	minRowHeight:60,
	scrollable: true,
	scrollType:'vertical',
	backgroundColor:'transparent'
});

bottomView.setData(tableRows,{animated:false});


var bottomSheetController = TiBottomSheetControllerModule.createBottomSheet({
	detents:{large:true,medium:true}, // The object of heights where a sheet can rest.
	preferredCornerRadius:20, // The corner radius that the sheet attempts to present with.
	prefersEdgeAttachedInCompactHeight:false, // A Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class.
	prefersScrollingExpandsWhenScrolledToEdge:false, // A Boolean value that determines whether scrolling expands the sheet to a larger detent.
	widthFollowsPreferredContentSizeWhenEdgeAttached:false, // A Boolean value that determines whether the sheet's width matches its view controller's preferred content size.
	prefersGrabberVisible:true, // A Boolean value that determines whether the sheet shows a grabber at the top.
	largestUndimmedDetentIdentifier:'medium', // medium or large - if not set, it is full dimmed depending on activated detents - The largest detent that doesn’t dim the view underneath the sheet.
	contentView: bottomView. // View (any kind), Window or NavigationWindow
});

bottomSheetController.addEventListener('dismissing', function() {
	console.log("bottomSheet dismissing");
});

bottomSheetController.addEventListener('closed', function() {
	console.log("bottomSheet closed");
});

bottomSheetController.addEventListener('opened', function() {
	console.log("bottomSheet opened");
});
bottomSheetController.addEventListener('detentChange', function(e) {
	console.log("\n\n bottomSheet detentChange: "+JSON.stringify(e)+"\n\n");

	console.log("returns the at any time you call the propery -> bottomSheetController.selectedDetentIdentifier: "+bottomSheetController.selectedDetentIdentifier);
});

bottomSheetController.show({ 
	animated:true
});

```

## License

MIT

## Author

Marc Bender
