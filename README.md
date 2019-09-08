# Titanium iOS 13+ Context Menu

Use the `UIPreviewInteraction` API in the Appcelerator Titanium SDK.

<img src="./example.gif" width="400" />

## Requirements

- [x] Titanium SDK 8.2.0+
- [x] iOS 13+

## How does it work?

Simply include the `ti.contextmenu` module in your tiapp.xml and call the `addInteraction`
method on any `Ti.UI.View` subclass (e.g. `Ti.UI.ImageView`).

## Example

```js
var win = Ti.UI.createWindow();

var image = Ti.UI.createView({
    width: 200,
    height: 200,
    backgroundColor: 'green'
});

image.addEventListener('interaction', function(event) {
    alert('Clicked at index: ' + event.index);
})

image.addInteraction({
    title: 'What do you want to do',
    identifier: 'main_menu',
    actions: [{
            identifier: 'edit',
            title: 'Edit …'
        },
        {
            identifier: 'delete',
            title: 'Delete',
            destructive: true
        }
    ]
});

win.add(image);
win.open();
```

## Known Issues

- [ ] Add compatibility for ListView & TableView via their delegate methods
- [ ] Add support for nested menus

## License

MIT

## Author

Hans Knöchel
