

return [[

	<!DOCTYPE html>
	<html lang="en">
	<head>
		<title id="title">{{title}}</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<meta name="description" content="{{description}}" />
		<meta name="keywords" content="{{keywords}}" />
		<meta name="author" content="{{author}}">


		<!--[if lte IE 8]><script src="/baseline/static/js/html5shiv.js"></script><![endif]-->
		<script type="text/javascript" src="/baseline/static/js/jquery.min.js"></script>
		<script type="text/javascript" src="/baseline/static/js/skel.min.js"></script>
		<script type="text/javascript" src="/baseline/static/js/skel-layers.min.js"></script>

		{{externalJS}}

		<script type="text/javascript" src="/static/widgets.js"></script>

		{{internalJS}}

		<script type="text/javascript">
			{{customJS}}
		</script>

		<noscript>
			<link rel="stylesheet" type="text/css" href="/baseline/static/css/skel.css" />
			<link rel="stylesheet" type="text/css" href="/baseline/static/css/style.css" />
			<link rel="stylesheet" type="text/css" href="/baseline/static/css/style-xlarge.css" />
		</noscript>


		{{externalCSS}}

		<link rel="stylesheet" type="text/css" href="/static/widgets.css" />

		{{internalCSS}}

		<style type="text/css">
			{{customCSS}}
		</style>
	</head>

	<body id="top">
		<div id="widgets"></div>
		<div id="popups"></div>
		<script type="text/javascript">
			{{initJS}}
		</script>
	</body>
	</html>

]]