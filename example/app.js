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