var win = Ti.UI.createWindow({
	layout: 'vertical',
	title: 'Ti.ContextMenu'
});
var nav = Ti.UI.createNavigationWindow({
	window: win
});
var label = Ti.UI.createLabel({
	text: 'Long-press the image below:',
	top: 50
});
var image = Ti.UI.createImageView({
	top: 20,
	width: 200,
	height: 200,
	borderRadius: 10,
	image: 'logo-titanium.png'
});
image.addEventListener('interaction', function(event) {
	alert('Clicked at index: ' + event.index);
});
image.addInteraction({
	identifier: 'main_menu',
	actions: [{
			identifier: 'edit',
			image: Ti.UI.iOS.systemImage('plus.circle'),
			title: 'Edit …'
		},
		{
			identifier: 'delete',
			title: 'Delete',
			destructive: true
		}
	]
});
const separator = Ti.UI.createView({
	height: 1,
	backgroundColor: '#e0e0e0',
	top: 40,
	bottom: 40,
	width: 300
});
var btn = Ti.UI.createButton({
	title: 'Show button options',
	menu: [{
		title: 'Action 1',
		identifier: '123'
	}, {
		title: 'Action 2',
		identifier: '456',
		destructive: true
	}]
})
btn.addEventListener('menuclick', function(event) {
	alert('Clicked at index: ' + event.index);
});
var btn2 = Ti.UI.createButton({
	image: Ti.UI.createView({
		width: 20,
		height: 20,
		backgroundColor: 'red'
	}).toImage(),
	menu: [{
		title: 'Action 1',
		identifier: '123'
	}, {
		title: 'Action 2',
		identifier: '456',
		destructive: true
	}]
})
btn2.addEventListener('menuclick', function(event) {
	alert('Clicked at index: ' + event.index);
});
var listView = Ti.UI.createListView({
	bottom: 100,
	sections: [Ti.UI.createListSection({
		items: generate10Items()
	})]
})

listView.addEventListener('menuclick', event => {
	alert('Clicked at sectionIndex: ' + event.sectionIndex + ', itemIndex: ' + event.itemIndex + ', actionIndex: ' + event.actionIndex);
});

win.rightNavButton = btn2;
win.add([label, image, separator, btn, listView]);
nav.open();

function generate10Items() {
	const item = {
		properties: {
			itemId: 1,
			title: 'Hello world',
			menu: [{
				title: 'Action 1',
				identifier: '123'
			}, {
				title: 'Action 2',
				identifier: '456',
				destructive: true
			}]
		}
	};

	return [item, item, item, item, item, item, item, item, item, item]
}