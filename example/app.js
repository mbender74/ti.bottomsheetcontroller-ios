// Example app for ti.bottomsheetcontroller module
var win = Ti.UI.createWindow({
    backgroundColor: 'white'
});

var TiBottomSheetControllerModule = require("ti.bottomsheetcontroller");

// Create content view for the bottom sheet
var contentView = Ti.UI.createView({
    backgroundColor: '#ffffff',
    layout: 'vertical'
});

var label = Ti.UI.createLabel({
    text: 'Bottom Sheet Content',
    font: { fontSize: 20, fontWeight: 'bold' },
    color: '#000',
    top: 60,
    left: 20,
    right: 20,
    textAlign: 'center'
});

var button = Ti.UI.createButton({
    title: 'Close Bottom Sheet',
    top: 100,
    left: 20,
    right: 20,
    height: 44
});

contentView.add(label);
contentView.add(button);

// Create close button
var closeButton = Ti.UI.createButton({
    title: '✕',
    width: 30,
    height: 30,
    font: { fontSize: 16 }
});

// Create the bottom sheet
var bottomSheetController = TiBottomSheetControllerModule.createBottomSheet({
    contentView: contentView,
    closeButton: closeButton,
    backgroundColor: '#ffffff',
    detents: {
        large: true,
        medium: true,
        small: true
    },
    startDetent: 'medium',
    prefersGrabberVisible: true,
    nonSystemSheet: true, // Set to false for iOS 15+ native sheet
    preferredCornerRadius: 14
});

// Handle close button click
button.addEventListener('click', function() {
    bottomSheetController.close({ animated: true });
});

closeButton.addEventListener('click', function() {
    bottomSheetController.close({ animated: true });
});

// Event listeners
bottomSheetController.addEventListener('open', function(e) {
    Ti.API.info('Bottom Sheet opened');
});

bottomSheetController.addEventListener('close', function(e) {
    Ti.API.info('Bottom Sheet closed');
});

bottomSheetController.addEventListener('dismissing', function(e) {
    Ti.API.info('Bottom Sheet dismissing');
});

bottomSheetController.addEventListener('detentChange', function(e) {
    Ti.API.info('Detent changed to: ' + e.selectedDetentIdentifier);
});

// Create open button
var openButton = Ti.UI.createButton({
    title: 'Open Bottom Sheet',
    top: 50,
    left: 20,
    right: 20,
    height: 44
});

openButton.addEventListener('click', function() {
    bottomSheetController.open({ animated: true });
});

win.add(openButton);
win.open();
