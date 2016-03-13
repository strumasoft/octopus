Widget.RepositoryStatusHeader = function (directoryName) {
    var data = {directoryName: directoryName}
    
	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">{{directoryName}}</div></h1>
			<nav id="nav">
				<ul>
				    <!-- Commit -->
					<li><div id="commitAction" class="hand" 
					    onclick='Widget.RepositoryStatusHeader.commit();'>
					    <i class="fa fa-chevron-circle-up"></i></div>
				    </li>
				
				    <!-- Update -->
				    {{?@ getURLParameter("repository") == "SVN"
					<li><div id="updateAction" class="hand" 
					    onclick='Widget.RepositoryStatusHeader.update();'>
					    <i class="fa fa-chevron-circle-down"></i></div>
				    </li>
				    }}?
				    
				    <!-- Revert/Reset -->
					<li><div id="revertAction" class="hand" 
					    onclick='Widget.RepositoryStatusHeader.revert();'>
					    <i class="fa fa-chevron-circle-left"></i></div>
				    </li>
				    
				    <!-- Merge -->
				    {{?@ getURLParameter("repository") == "SVN"
					<li><div id="mergeAction" class="hand" 
					    onclick='Widget.RepositoryStatusHeader.merge();'>
					    <i class="fa fa-sitemap"></i></div>
				    </li>
				    }}?
				    
				    <!-- Refresh/Clean -->
				    {{?@ getURLParameter("repository") == "SVN"
					<li><div id="refreshAction" class="hand" 
					    onclick='Widget.RepositoryStatusHeader.refresh();'>
					    <i class="fa fa-refresh"></i></div>
				    </li>
				    }}?
				    {{?@ getURLParameter("repository") == "GIT"
					<li><div id="refreshAction" class="hand" 
					    onclick='Widget.RepositoryStatusHeader.refresh();'>
					    <i class="fa fa-eraser"></i></div>
				    </li>
				    }}?
				
				    <!-- Create/Add -->
					<li><div id="addPathAction" class="hand" 
					    onclick='Widget.RepositoryStatusHeader.addPath();'>
					    <i class="fa fa-plus"></i></div>
				    </li>
				    
				    <!-- Remove/Delete -->
					<li><div id="deletePathAction" class="hand" 
					    onclick='Widget.RepositoryStatusHeader.deletePath();'>
					    <i class="fa fa-minus"></i></div>
				    </li>
				    
				    <!-- Edit -->
					<li><div id="editFileAction" class="hand" 
					    onclick='Widget.RepositoryStatusHeader.editFile();'>
					    <i class="fa fa-pencil-square-o"></i></div>
				    </li>
				
				    <!-- Compare -->
					<li><div id="compareAction" class="button special" 
					    onclick='Widget.RepositoryStatusHeader.compare();'>
				        Compare</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.RepositoryStatusHeader.prototype = {
	constructor: Widget.RepositoryStatusHeader
}


//
// ifFileIsChecked
//

Widget.RepositoryStatusHeader.ifCheckboxIsChecked = function (f) {
    $(".compareRevision").each(function(index) {
        if ($(this).is(':checked')) {
            f($(this))
        }
    })
}


//
// commit
//

Widget.RepositoryStatusHeader.commit = function () {
    var params = {}
    params.directoryName = getURLParameter("directoryName")
    
    var i = 0
    Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
        if (isEmpty(checkbox.attr("newFileName"))) {
            params["f" + i] = encodeURIComponent(checkbox.attr("fileName"))
        } else {
            params["f" + i] = encodeURIComponent(checkbox.attr("newFileName"))
        }
        
        i++
    })
    
    if (i < 1) {
        var infoPopup = new Widget.InfoPopup({info: "Select at least 1 file to commit!"})
        return
    }
    
    var commitPopup = new Widget.OneFieldPopup({info:"Commit code.", placeholder: "Message", proceed: function (guid) {
        var message = $("#" + guid).val()
		if (!isEmpty(message)) {
            params.message = encodeURIComponent(message)
            
            $.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryCommitUrl, params))
    			.success(function (data) {
    		        Widget.successHandler(data)
    			})
    			.error(Widget.errorHandler)
    			
    		this.delete()
		} else {
		    var infoPopup = new Widget.InfoPopup({info: "Message required!"})
		}
	}})
}


//
// update
//

Widget.RepositoryStatusHeader.update = function () {
    var paths = []
    Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
        paths.push(checkbox.attr("fileName"))
    })
    
    var directoryName = getURLParameter("directoryName")
    if (paths.length > 1) {
        var infoPopup = new Widget.InfoPopup({info: "Select 1 file/directory to update!"})
        return
    } else if (paths.length == 1) {
        directoryName = paths[0]
    }
    
    if (!isEmpty(directoryName)) {
        var updatePopup = new Widget.OneFieldPopup({info:"Update to revision.", placeholder: "Revision", proceed: function (guid) {
            var params = {}
            params.path = encodeURIComponent(directoryName)
            
            var revision = $("#" + guid).val()
            if (!isEmpty(revision)) {
                params.revision = revision
            }
            
    		$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryUpdateUrl, params))
    			.success(function (data) {
    		        Widget.successHandler(data)
    			})
    			.error(Widget.errorHandler)
    		
    		this.delete()
    	}})
    } else {
        var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
    }
}


//
// revert/reset
//

Widget.RepositoryStatusHeader.revert = function () {
    var directoryName = getURLParameter("directoryName")
    
    var paths = []
    Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
        paths.push(checkbox.attr("fileName"))
    })
    
    if (paths.length > 1) {
        var infoPopup = new Widget.InfoPopup({info: "Select 1 file to revert!"})
    } else {
        var path
        var params = {}
        if (paths.length == 0) {
            path = getURLParameter("directoryName")
            params.path = encodeURIComponent(path)
            params.recursively = "true"
            params.directoryName = encodeURIComponent(directoryName)
        } else {
            path = paths[0]
            params.path = encodeURIComponent(path)
            params.directoryName = encodeURIComponent(directoryName)
        }
        
        var revertPopup = new Widget.QuestionPopup({question: "Revert " + path + "?", proceed: function () {
    		$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryRevertUrl, params))
    			.success(function (data) {
    		        Widget.successHandler(data)
    			})
    			.error(Widget.errorHandler)
    		
    		this.delete()
    	}})
    }
}


//
// merge
//

Widget.RepositoryStatusHeader.merge = function () {
	var directoryName = getURLParameter("directoryName")
    
    if (!isEmpty(directoryName)) {
    	var updatePopup = new Widget.TwoFieldsPopup({info:"Merge revisions.", placeholder1: "From Revision", placeholder2: "To Revision", proceed: function (fromRevisionGuid, toRevisionGuid) {
    		var fromRevision = $("#" + fromRevisionGuid).val()
    		var toRevision = $("#" + toRevisionGuid).val()
    		
    		if (!isEmpty(fromRevision) && !isEmpty(toRevision)) {
    		    var params = {}
                params.path = encodeURIComponent(directoryName)
                params.fromRevision = fromRevision
                params.toRevision = toRevision
                
        		$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryMergeUrl, params))
        			.success(function (data) {
        		        Widget.successHandler(data)
        			})
        			.error(Widget.errorHandler)
        		
        		this.delete()
    		} else {
    		    this.delete()
    		    var infoPopup = new Widget.InfoPopup({info: "Both revisions are required!"})
    		}
    	}})
    } else {
        var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
    }
}


//
// refresh/clean
//

Widget.RepositoryStatusHeader.refresh = function () {
    var directoryName = getURLParameter("directoryName")
    
    var path
    var isDir
    
    var paths = []
    Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
        paths.push(checkbox.attr("fileName"))
    })
    
    if (paths.length > 1) {
        var infoPopup = new Widget.InfoPopup({info: "Select 1 file/directory to refresh!"})
        return
    } else if (paths.length == 1) {
        path = paths[0]
        isDir = false
    } else {
        path = directoryName
        isDir = true
    }
    
    if (!isEmpty(path)) {
        var refreshOrClean
        if (getURLParameter("repository") == "SVN") {
            refreshOrClean = "Refresh "
        } else if (getURLParameter("repository") == "GIT") {
            if (isDir) {
                refreshOrClean = "Remove untracked files in "
            } else {
                refreshOrClean = "Remove untracked "
            }
        }
        
        var refreshPopup = new Widget.QuestionPopup({question: refreshOrClean + path + "?", proceed: function () {
            var params = {}
            params.path = encodeURIComponent(path)
            params.directoryName = encodeURIComponent(directoryName)
            
    		$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryRefreshUrl, params))
    			.success(function (data) {
    		        Widget.successHandler(data)
    			})
    			.error(Widget.errorHandler)
    		
    		this.delete()
    	}})
    } else {
        var infoPopup = new Widget.InfoPopup({info: "directory is refreshed!"})
    }
}


//
// create/add
//

Widget.RepositoryStatusHeader.addPath = function () {
    var directoryName = getURLParameter("directoryName")
    
    var paths = []
    Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
        if (isEmpty(checkbox.attr("newFileName"))) {
            paths.push(checkbox.attr("fileName"))
        } else {
            paths.push(checkbox.attr("newFileName"))
        }
    })
    
    if (paths.length != 1) {
        var infoPopup = new Widget.InfoPopup({info: "Select 1 file to add!"})
    } else {
        var path = paths[0]
        
        var addPopup = new Widget.QuestionPopup({question: "Add " + path + "?", proceed: function () {
    		$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryAddUrl, {path: encodeURIComponent(path), directoryName: encodeURIComponent(directoryName)}))
    			.success(function (data) {
    		        Widget.successHandler(data)
    			})
    			.error(Widget.errorHandler)
    		
    		this.delete()
    	}})
    }
}


//
// remove/delete
//

Widget.RepositoryStatusHeader.deletePath = function () {
    var directoryName = getURLParameter("directoryName")
    
    var paths = []
    Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
        if (isEmpty(checkbox.attr("newFileName"))) {
            paths.push(checkbox.attr("fileName"))
        } else {
            paths.push(checkbox.attr("newFileName"))
        }
    })
    
    if (paths.length != 1) {
        var infoPopup = new Widget.InfoPopup({info: "Select 1 file to delete!"})
    } else {
        var path = paths[0]
        
        var deletePopup = new Widget.QuestionPopup({question: "Delete " + path + "?", proceed: function () {
    		$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryDeleteUrl, {path: encodeURIComponent(path), directoryName: encodeURIComponent(directoryName)}))
    			.success(function (data) {
    		        Widget.successHandler(data)
    			})
    			.error(Widget.errorHandler)
    		
    		this.delete()
    	}})
    }
}

//
// edit
//

Widget.RepositoryStatusHeader.editFile = function () {
    var directoryName = getURLParameter("directoryName")
    
    var paths = []
    Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
        if (isEmpty(checkbox.attr("newFileName"))) {
            paths.push(checkbox.attr("fileName"))
        } else {
            paths.push(checkbox.attr("newFileName"))
        }
    })
    
    if (paths.length != 1) {
        var infoPopup = new Widget.InfoPopup({info: "Select 1 file to edit!"})
    } else {
        var path = paths[0]
        
        var fileName
        if (getURLParameter("repository") == "SVN") {
            fileName = path
        } else if (getURLParameter("repository") == "GIT") {
            fileName = directoryName + "/" + path
        }
        
        var newSessionUrl = Widget.EditorHeader.newSessionUrl(
            property.editorUrl + property.editorEditFileUrl, 
            {directoryName: encodeURIComponent(directoryName), fileName: encodeURIComponent(fileName)})
        
        window.open(newSessionUrl)
    }
}


//
// compare
//

Widget.RepositoryStatusHeader.compare = function () {
    if (getURLParameter("repository") == "SVN") {
        Widget.RepositoryStatusHeader.compareSVN()
    } else if (getURLParameter("repository") == "GIT") {
        Widget.RepositoryStatusHeader.compareGIT()
    }
}

Widget.RepositoryStatusHeader.compareSVN = function () {
    var oldRevision, newRevision, fileName, revertRevisions
    var revisions = []
    
    Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
        revisions.push(checkbox.attr("newRevision"))
        revisions.push(checkbox.attr("oldRevision"))
        fileName = checkbox.attr("fileName")
        revertRevisions = checkbox.attr("revertRevisions")
    })
    
    if (revisions.length == 2) {
        oldRevision = revisions[1]
        newRevision = revisions[0]
        
        Widget.compareSVNRepositoryFileHistory(oldRevision, newRevision, fileName, revertRevisions)
    } else {
        var infoPopup = new Widget.InfoPopup({info: "Select 1 file to compare!"})
    }
}

Widget.RepositoryStatusHeader.compareGIT = function () {
    var oldRevision, newRevision, oldFileName, newFileName
    var revisions = []
    
    Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
        revisions.push(checkbox.attr("newRevision"))
        revisions.push(checkbox.attr("oldRevision"))
        fileName = checkbox.attr("fileName")
        newFileName = checkbox.attr("newFileName")
    })
    
    if (revisions.length == 2) {
        oldRevision = revisions[1]
        newRevision = revisions[0]
        
        oldFileName = fileName
        if (isEmpty(newFileName)) {
            newFileName = fileName
        } 
        
        Widget.compareGITRepositoryFileHistory(oldRevision, oldFileName, newRevision, newFileName)
    } else {
        var infoPopup = new Widget.InfoPopup({info: "Select 1 file to compare!"})
    }
}