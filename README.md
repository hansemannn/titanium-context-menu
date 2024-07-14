# Titanium iOS 14+ Context Menus

Use the `UIPreviewInteraction` and `UIMenu` API in the Titanium SDK.

<img src="./example.gif" width="400" />

## Requirements

- [x] Titanium SDK 9.2.0+
- [x] iOS 14+

## How does it work?

Simply include the `ti.contextmenu` module in your tiapp.xml and let the magic happen.

### UIPreviewInteraction

Call the `addInteraction` method on any `Ti.UI.View` subclass (e.g. `Ti.UI.ImageView`).

### UIMenu

Add the `menu` property to a `Ti.UI.Button`. Since version 2.1.0, the `menu` property also works for buttons in the 
navigation bar, e.g. `rightNavButton` or `leftNavButton`, but only if you have either a `title` or `image`.
Since version 2.2.0, the menu also works for the `ListView` and `TableView` API. Since version 4.0.0, you can use nested menus as well.

## Full Example

See the `example/app.js` for a full-featured example.

## License

MIT

## Author

Hans Knöchel
