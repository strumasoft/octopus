Widget.RepositoryFileHistoryHeader = function (fileName) {
	var data = {fileName: fileName}

	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">{{fileName}}</div></h1>
			<nav id="nav">
				<ul>
					<!-- Compare -->
					<li><div id="compareAction" class="button special" 
						onclick='Widget.RepositoryFileHistoryHeader.compare();'>
						Compare</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.RepositoryFileHistoryHeader.prototype = {
	constructor: Widget.RepositoryFileHistoryHeader
}

Widget.RepositoryFileHistoryHeader.compare = function () {
	if (getURLParameter("repository") == "SVN") {
		Widget.RepositoryFileHistoryHeader.compareSVN()
	} else if (getURLParameter("repository") == "GIT") {
		Widget.RepositoryFileHistoryHeader.compareGIT()
	}
}

Widget.RepositoryFileHistoryHeader.compareSVN = function () {
	var oldRevision, newRevision, fileName
	var revisions = []

	$(".compareRevision").each(function(index) {
		if ($(this).is(':checked')) {
			revisions.push($(this).attr("revision"))
		}
	})

	if (revisions.length == 2) {
		oldRevision = revisions[1]
		newRevision = revisions[0]
		var fileName = getURLParameter("fileName")

		Widget.compareSVNRepositoryFileHistory(oldRevision, newRevision, fileName)
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select 2 revisions to compare!"})
	}
}

Widget.RepositoryFileHistoryHeader.compareGIT = function () {
	var oldRevision, oldFileName, newRevision, newFileName
	var revisions = []

	$(".compareRevision").each(function(index) {
		if ($(this).is(':checked')) {
			revisions.push($(this).attr("id"))
		}
	})

	if (revisions.length == 2) {
		oldRevision = $("#" + revisions[1]).attr("revision")
		oldFileName = $("#" + revisions[1]).attr("toFile")
		newRevision = $("#" + revisions[0]).attr("revision")
		newFileName = $("#" + revisions[0]).attr("toFile")

		Widget.compareGITRepositoryFileHistory(oldRevision, oldFileName, newRevision, newFileName)
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select 2 revisions to compare!"})
	}
}

Widget.compareSVNRepositoryFileHistory = function (oldRevision, newRevision, fileName, revertRevisions) {
	fileName = encodeURIComponent(fileName)

	$("#compareAction").html('<i class="fa fa-spinner"></i>')

	var oldRevisionContenUrl, newRevisionContenUrl

	oldRevisionContenUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileRevisionContentUrl, {revision: oldRevision, fileName: fileName})
	if (newRevision == "LOCAL") {
		newRevisionContenUrl = property.editorUrl + property.editorFileContentUrl + "?f=" + fileName
	} else {
		newRevisionContenUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileRevisionContentUrl, {revision: newRevision, fileName: fileName})
	}

	var fileDiffUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileDiffUrl, {oldRevision: oldRevision, newRevision: newRevision, fileName: fileName})

	var originalContent, changedContent
	$.get(oldRevisionContenUrl) // oldRevision
		.success(function (content) {
			originalContent = content

			$.get(newRevisionContenUrl) // newRevision
				.success(function (content) {
					changedContent = content

					if (!isEmpty(revertRevisions) && revertRevisions == "true") {
						var swap = originalContent
						originalContent = changedContent
						changedContent = swap
					}

					diffUsingJS(0, originalContent, changedContent)

					$("#comparator").prettyTextDiff({
						cleanup: $("#cleanup").is(":checked"),
						originalContent: originalContent,
						changedContent: changedContent,
						diffContainer: ".diffbox"
					});

					$.get(fileDiffUrl)
						.success(function (content) {
							$("#patch .diffbox").html(Widget.decoratePatch(Widget.createHTML(content)))

							$("#compareAction").html('Compare')
						})
						.error(function(jqXHR, textStatus, errorThrown) {
							Widget.errorHandler(jqXHR, textStatus, errorThrown)
							$("#compareAction").html('Compare')
						})
				})
				.error(function(jqXHR, textStatus, errorThrown) {
					Widget.errorHandler(jqXHR, textStatus, errorThrown)
					$("#compareAction").html('Compare')
				})
		})
		.error(function(jqXHR, textStatus, errorThrown) {
			Widget.errorHandler(jqXHR, textStatus, errorThrown)
			$("#compareAction").html('Compare')
		})
}

Widget.compareGITRepositoryFileHistory = function (oldRevision, oldFileName, newRevision, newFileName) {
	var directoryName = getURLParameter("directoryName")
	directoryName = encodeURIComponent(directoryName)

	oldFileName = encodeURIComponent(oldFileName)
	newFileName = encodeURIComponent(newFileName)

	$("#compareAction").html('<i class="fa fa-spinner"></i>')

	var oldRevisionContenUrl, newRevisionContenUrl

	oldRevisionContenUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileRevisionContentUrl, {revision: oldRevision, fileName: oldFileName, directoryName: directoryName})
	if (newRevision == "LOCAL") {
		newRevisionContenUrl = property.editorUrl + property.editorFileContentUrl + "?f=" + directoryName + "/" + newFileName
	} else {
		newRevisionContenUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileRevisionContentUrl, {revision: newRevision, fileName: newFileName, directoryName: directoryName})
	}

	var fileDiffUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileDiffUrl, {oldRevision: oldRevision, newRevision: newRevision, fileName: oldFileName, newFileName: newFileName, directoryName: directoryName})

	var originalContent, changedContent
	$.get(oldRevisionContenUrl) // oldRevision
		.success(function (content) {
			originalContent = content

			$.get(newRevisionContenUrl) // newRevision
				.success(function (content) {
					changedContent = content

					diffUsingJS(0, originalContent, changedContent)

					$("#comparator").prettyTextDiff({
						cleanup: $("#cleanup").is(":checked"),
						originalContent: originalContent,
						changedContent: changedContent,
						diffContainer: ".diffbox"
					});

					$.get(fileDiffUrl)
						.success(function (content) {
							$("#patch .diffbox").html(Widget.decoratePatch(Widget.createHTML(content)))

							$("#compareAction").html('Compare')
						})
						.error(function(jqXHR, textStatus, errorThrown) {
							Widget.errorHandler(jqXHR, textStatus, errorThrown)
							$("#compareAction").html('Compare')
						})
				})
				.error(function(jqXHR, textStatus, errorThrown) {
					Widget.errorHandler(jqXHR, textStatus, errorThrown)
					$("#compareAction").html('Compare')
				})
		})
		.error(function(jqXHR, textStatus, errorThrown) {
			Widget.errorHandler(jqXHR, textStatus, errorThrown)
			$("#compareAction").html('Compare')
		})
}

Widget.decoratePatch = function (text) {
	// baseline/static/js/jquery.pretty-text-diff.js
	// core/src/js/widget.js
	var delimiters = [
		{open: "\n+", close: "\n", bypass: "\n+++"}, 
		{open: "\n-", close: "\n", bypass: "\n---"},
		{open: "\r+", close: "\r", bypass: "\r+++"}, 
		{open: "\r-", close: "\r", bypass: "\r---"}
	]
	var wrappers = [{open: "<ins>", close: "</ins>"}, {open: "<del>", close: "</del>"}]

	var substrings = []

	var iteratorIndex = 0

	do {
		var startDelimiterIndex, index, delimiter, wrapper

		// find the closest delimiter index
		var closestDelimiterIndex = text.length
		for (var i = 0; i < delimiters.length; i++) {
			startDelimiterIndex = text.indexOf(delimiters[i].open, iteratorIndex)
			if (startDelimiterIndex >= 0 && startDelimiterIndex < closestDelimiterIndex) {
				closestDelimiterIndex = startDelimiterIndex
				index = i
			}
		}

		// get closest index, delimiter and wrapper
		startDelimiterIndex = closestDelimiterIndex
		delimiter = delimiters[index]
		wrapper = wrappers[index]

		// bypass beggining headers
		if (startDelimiterIndex < text.length && startDelimiterIndex == text.indexOf(delimiter.bypass, iteratorIndex)) {

			substrings.push(text.substring(iteratorIndex, startDelimiterIndex + delimiter.bypass.length))

			iteratorIndex = startDelimiterIndex + delimiter.bypass.length
		} else if (startDelimiterIndex >= 0 && startDelimiterIndex < text.length) {
			substrings.push(text.substring(iteratorIndex, startDelimiterIndex))

			var startExpressionIndex = startDelimiterIndex + delimiter.open.length
			var endDelimiterIndex = text.indexOf(delimiter.close, startExpressionIndex)

			if (endDelimiterIndex < 0) {
				endDelimiterIndex = text.length
			}

			// from beginning of delimiter.open (inclusive) to beginning of delimiter.close (exclusive)
			var line = text.substring(startDelimiterIndex, endDelimiterIndex)

			substrings.push(wrapper.open + line + wrapper.close)

			// continue from beginning of delimiter.close
			iteratorIndex = endDelimiterIndex
		} else {
			substrings.push(text.substring(iteratorIndex, text.length))
		}
	} while (startDelimiterIndex >= 0 && startDelimiterIndex < text.length)

	// concat substrings
	return substrings.join("")
}