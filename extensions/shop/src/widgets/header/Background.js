Widget.Background = function () {
	$("body").css('height', $(window).height())

	var setBackgroundImage = function (imageUrl) {
		$("body").css('background', '#FFFFF1 url(' + imageUrl + ') center 0px no-repeat')
	}


	var imageUrl1 = "http://s1emagst.akamaized.net/layout/bg/images/db/5/7385.jpg"
	var imageUrl2 = "http://s1emagst.akamaized.net/layout/bg/images/db/5/7391.jpg"

	skel.on('change', function() {
		if (skel.isActive('small')) {
			setBackgroundImage(imageUrl1)
		} else {
			setBackgroundImage(imageUrl2) 
		}
	});
}

Widget.Background.prototype = {
	constructor: Widget.Background
}