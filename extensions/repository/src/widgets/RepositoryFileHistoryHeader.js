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
                            $("#patch .diffbox").html(Widget.createHTML(content))
                            
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
                            $("#patch .diffbox").html(Widget.createHTML(content))
                            
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