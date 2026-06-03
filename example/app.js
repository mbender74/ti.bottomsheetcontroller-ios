/**
 * Titanium BottomSheetController - Comprehensive Example
 * 
 * Demonstrates all features:
 * - System Sheet (iOS 15+) and Custom Sheet modes
 * - Standard and custom detents
 * - Event handling (open, close, dismissing, detentChange)
 * - Pan gesture control
 * - TableView content
 * - Dynamic detent switching
 */

var TiBottomSheetControllerModule = require("ti.bottomsheetcontroller");

var win = Ti.UI.createWindow({
    backgroundColor: '#f5f5f7',
    layout: 'vertical'
});

// ===========================================================================
// STATE MANAGEMENT
// ===========================================================================
var currentSheet = null;

// ===========================================================================
// CONTENT VIEWS
// ===========================================================================

/**
 * Simple content view with buttons
 */
function createSimpleContentView() {
    var contentView = Ti.UI.createView({
        backgroundColor: '#ffffff',
        layout: 'vertical'
    });

    var title = Ti.UI.createLabel({
        text: 'Bottom Sheet Content',
        font: { fontSize: 22, fontWeight: 'bold' },
        color: '#000000',
        top: 60,
        left: 20,
        right: 20,
        textAlign: 'center'
    });

    var description = Ti.UI.createLabel({
        text: 'This is a simple bottom sheet with standard detents. Drag the handle or swipe up/down to change detent size.',
        font: { fontSize: 14 },
        color: '#666666',
        top: 100,
        left: 20,
        right: 20,
        textAlign: 'center'
    });

    var closeButton = Ti.UI.createButton({
        title: 'Close Bottom Sheet',
        top: 140,
        left: 20,
        right: 20,
        height: 44
    });

    contentView.add(title);
    contentView.add(description);
    contentView.add(closeButton);

    closeButton.addEventListener('click', function() {
        if (currentSheet) {
            currentSheet.close({ animated: true });
        }
    });

    return contentView;
}

/**
 * TableView content view with many items
 */
function createTableViewContentView() {
    var tableData = [];
    for (var i = 1; i <= 30; i++) {
        tableData.push({
            title: 'Item ' + i,
            subtitle: 'Description for item ' + i,
            hasDetail: true
        });
    }

    var tableView = Ti.UI.createTableView({
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        backgroundColor: '#ffffff',
        minRowHeight: 60,
        separatorColor: '#e5e5ea'
    });

    tableView.setData(tableData);

    tableView.addEventListener('click', function(e) {
        Ti.API.info('Row clicked: ' + e.row.title);
        Ti.UI.createNotification({
            message: e.row.title + ' selected'
        }).show();
    });

    return tableView;
}

/**
 * Content view with custom controls
 */
function createControlsContentView() {
    var contentView = Ti.UI.createView({
        backgroundColor: '#ffffff',
        layout: 'vertical'
    });

    var title = Ti.UI.createLabel({
        text: 'Interactive Controls',
        font: { fontSize: 20, fontWeight: 'bold' },
        top: 50,
        left: 20,
        right: 20,
        textAlign: 'center'
    });

    var switchControl = Ti.UI.createSwitch({
        value: false,
        top: 90,
        left: 20,
        right: 20,
        height: 30
    });

    var slider = Ti.UI.createSlider({
        min: 0,
        max: 100,
        value: 50,
        top: 130,
        left: 20,
        right: 20,
        height: 30
    });

    var label = Ti.UI.createLabel({
        text: 'Slider value: 50',
        font: { fontSize: 14 },
        color: '#666666',
        top: 170,
        left: 20,
        right: 20,
        textAlign: 'center'
    });

    slider.addEventListener('change', function(e) {
        label.text = 'Slider value: ' + Math.round(e.value);
    });

    contentView.add(title);
    contentView.add(switchControl);
    contentView.add(slider);
    contentView.add(label);

    return contentView;
}

// ===========================================================================
// CLOSE BUTTON (reusable)
// ===========================================================================
function createCloseButton() {
    return Ti.UI.createButton({
        title: '✕',
        width: 32,
        height: 32,
        font: { fontSize: 16, fontWeight: 'bold' },
        color: '#007aff'
    });
}

// ===========================================================================
// SHEET CREATION FUNCTIONS
// ===========================================================================

/**
 * Example 1: Simple Custom Sheet with standard detents
 */
function openSimpleCustomSheet() {
    var contentView = createSimpleContentView();
    var closeButton = createCloseButton();

    currentSheet = TiBottomSheetControllerModule.createBottomSheet({
        contentView: contentView,
        closeButton: closeButton,
        backgroundColor: '#ffffff',

        // Detents configuration
        detents: {
            large: true,
            medium: true,
            small: true
        },
        startDetent: 'medium',

        // Appearance
        prefersGrabberVisible: true,
        preferredCornerRadius: 16,
        nonSystemSheetTopShadow: true,

        // Mode
        nonSystemSheet: true  // Custom Sheet mode
    });

    closeButton.addEventListener('click', function() {
        currentSheet.close({ animated: true });
    });

    setupEventListeners(currentSheet);
    currentSheet.open({ animated: true });
}

/**
 * Example 2: System Sheet (iOS 15+) with native behavior
 */
function openSystemSheet() {
    var contentView = createSimpleContentView();
    var closeButton = createCloseButton();

    currentSheet = TiBottomSheetControllerModule.createBottomSheet({
        contentView: contentView,
        closeButton: closeButton,
        backgroundColor: '#ffffff',

        // Detents
        detents: {
            large: true,
            medium: true,
            small: false  // Not available in System Sheet
        },
        startDetent: 'medium',

        // System Sheet specific properties
        prefersGrabberVisible: true,
        preferredCornerRadius: 12,
        prefersEdgeAttachedInCompactHeight: false,
        prefersScrollingExpandsWhenScrolledToEdge: false,

        nonSystemSheet: false  // System Sheet mode
    });

    closeButton.addEventListener('click', function() {
        currentSheet.close({ animated: true });
    });

    setupEventListeners(currentSheet);
    currentSheet.open({ animated: true });
}

/**
 * Example 3: Custom Detents (iOS 16+)
 */
function openCustomDetentsSheet() {
    var contentView = createControlsContentView();
    var closeButton = createCloseButton();

    currentSheet = TiBottomSheetControllerModule.createBottomSheet({
        contentView: contentView,
        closeButton: closeButton,
        backgroundColor: '#ffffff',

        // Disable standard detents
        detents: {
            large: false,
            medium: false,
            small: false
        },

        // Define custom detents with user-defined keys
        customDetents: {
            compact: 150,    // 150 points high
            standard: 280,   // 280 points high
            expanded: 420    // 420 points high
        },

        startDetent: 'standard',
        prefersGrabberVisible: true,
        preferredCornerRadius: 16,
        nonSystemSheet: false  // System Sheet for custom detents (iOS 16+)
    });

    closeButton.addEventListener('click', function() {
        currentSheet.close({ animated: true });
    });

    setupEventListeners(currentSheet);
    currentSheet.open({ animated: true });
}

/**
 * Example 4: TableView with scrolling
 */
function openTableViewSheet() {
    var contentView = createTableViewContentView();
    var closeButton = createCloseButton();

    currentSheet = TiBottomSheetControllerModule.createBottomSheet({
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
        preferredCornerRadius: 14,
        nonSystemSheetTopShadow: true,
        nonSystemSheet: true
    });

    closeButton.addEventListener('click', function() {
        currentSheet.close({ animated: true });
    });

    setupEventListeners(currentSheet);
    currentSheet.open({ animated: true });
}

/**
 * Example 5: Sheet with pan gesture disabled
 */
function openPanDisabledSheet() {
    var contentView = createSimpleContentView();
    var closeButton = createCloseButton();

    // Change description text
    contentView.children[1].text = 'Pan gesture is disabled. Only the close button can dismiss this sheet.';

    currentSheet = TiBottomSheetControllerModule.createBottomSheet({
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
        preferredCornerRadius: 16,
        nonSystemSheetTopShadow: true,

        // Disable pan gesture (drag down to close)
        nonSystemSheetDisablePanGestureDismiss: true,

        nonSystemSheet: true
    });

    closeButton.addEventListener('click', function() {
        currentSheet.close({ animated: true });
    });

    setupEventListeners(currentSheet);
    currentSheet.open({ animated: true });
}

/**
 * Example 6: System Sheet with pan gesture disabled
 */
function openSystemPanDisabledSheet() {
    var contentView = createSimpleContentView();
    var closeButton = createCloseButton();

    // Change description text
    contentView.children[1].text = 'System Sheet with pan gesture disabled. Only the close button can dismiss this sheet.';

    currentSheet = TiBottomSheetControllerModule.createBottomSheet({
        contentView: contentView,
        closeButton: closeButton,
        backgroundColor: '#ffffff',

        detents: {
            large: true,
            medium: true,
            small: false
        },
        startDetent: 'medium',

        prefersGrabberVisible: true,
        preferredCornerRadius: 12,

        // Disable pan gesture for System Sheet
        systemSheetDisablePanGestureDismiss: true,

        nonSystemSheet: false
    });

    closeButton.addEventListener('click', function() {
        currentSheet.close({ animated: true });
    });

    setupEventListeners(currentSheet);
    currentSheet.open({ animated: true });
}

/**
 * Example 7: Custom heights
 */
function openCustomHeightsSheet() {
    var contentView = createControlsContentView();
    var closeButton = createCloseButton();

    currentSheet = TiBottomSheetControllerModule.createBottomSheet({
        contentView: contentView,
        closeButton: closeButton,
        backgroundColor: '#ffffff',

        detents: {
            large: true,
            medium: true,
            small: true
        },
        startDetent: 'small',

        // Custom heights for each detent
        nonSystemSheetSmallHeight: 180,
        nonSystemSheetMediumHeight: 350,
        nonSystemSheetLargeHeight: 550,

        prefersGrabberVisible: true,
        preferredCornerRadius: 16,
        nonSystemSheetTopShadow: true,
        nonSystemSheetHandleColor: '#007aff',

        nonSystemSheet: true
    });

    closeButton.addEventListener('click', function() {
        currentSheet.close({ animated: true });
    });

    setupEventListeners(currentSheet);
    currentSheet.open({ animated: true });
}

// ===========================================================================
// EVENT LISTENERS SETUP
// ===========================================================================
function setupEventListeners(sheet) {
    sheet.addEventListener('open', function(e) {
        Ti.API.info('[Event] Bottom sheet opened');
    });

    sheet.addEventListener('close', function(e) {
        Ti.API.info('[Event] Bottom sheet closed');
        currentSheet = null;
    });

    sheet.addEventListener('dismissing', function(e) {
        Ti.API.info('[Event] Bottom sheet dismissing...');
    });

    sheet.addEventListener('detentChange', function(e) {
        Ti.API.info('[Event] Detent changed to: ' + e.selectedDetentIdentifier);
        Ti.API.info('[Event] Current detent (via property): ' + sheet.selectedDetentIdentifier);
    });
}

// ===========================================================================
// UI SETUP
// ===========================================================================

var title = Ti.UI.createLabel({
    text: 'BottomSheetController Examples',
    font: { fontSize: 24, fontWeight: 'bold' },
    color: '#000000',
    top: 60,
    left: 20,
    right: 20,
    textAlign: 'center'
});

var subtitle = Ti.UI.createLabel({
    text: 'Tap a button to open a bottom sheet example',
    font: { fontSize: 14 },
    color: '#666666',
    top: 95,
    left: 20,
    right: 20,
    textAlign: 'center'
});

var buttonContainer = Ti.UI.createView({
    layout: 'vertical',
    top: 130,
    left: 20,
    right: 20
});

var buttons = [
    { title: 'Simple Custom Sheet', color: '#007aff', action: openSimpleCustomSheet },
    { title: 'System Sheet (iOS 15+)', color: '#5856d6', action: openSystemSheet },
    { title: 'Custom Detents (iOS 16+)', color: '#ff2d55', action: openCustomDetentsSheet },
    { title: 'TableView with Scrolling', color: '#00c7be', action: openTableViewSheet },
    { title: 'Pan Gesture Disabled', color: '#ff9500', action: openPanDisabledSheet },
    { title: 'System Sheet (Pan Disabled)', color: '#af52de', action: openSystemPanDisabledSheet },
    { title: 'Custom Heights', color: '#34c759', action: openCustomHeightsSheet }
];

buttons.forEach(function(btnConfig, index) {
    var button = Ti.UI.createButton({
        title: btnConfig.title,
        top: index * 52,
        height: 44,
        color: '#ffffff',
        backgroundColor: btnConfig.color
    });

    button.addEventListener('click', function() {
        // Close existing sheet if open
        if (currentSheet) {
            currentSheet.close({ animated: true });
            setTimeout(btnConfig.action, 300);
        } else {
            btnConfig.action();
        }
    });

    buttonContainer.add(button);
});

win.add(title);
win.add(subtitle);
win.add(buttonContainer);
win.open();
