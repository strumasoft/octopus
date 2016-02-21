Widget.EditorHeader = function (title) {
    var data = {title: title}
    
	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">{{title}}</div></h1>
			<nav id="nav">
				<ul>
				    <!-- Login -->
				    <li><div id="login" class="hand" 
				        onclick='Widget.EditorHeader.login();'>
					    <i class="fa fa-user-secret"></i></div>
				    </li>
				    
				    <!-- Database -->
				    <li><a id="database" class="hand" style="color: white;"
				        href="{{@ property.databaseUrl + property.databaseHomeUrl}}" target="_blank">
					    <i class="fa fa-database"></i></a>
				    </li>
				    
				    <!-- Search -->
				    <li><div id="search" class="hand" 
				        onclick='Widget.EditorHeader.search();'>
					    <i class="fa fa-question"></i></div>
				    </li>
				
				    <!-- Home Directory -->
				    <li><div id="setHomeDirectoryAction" class="hand" 
				        onclick='Widget.EditorHeader.setHomeDirectory();'>
					    <i class="fa fa-home"></i></div>
				    </li>
				    
				    <!-- Open New Window -->
				    <li><a id="openNewWindowAction" class="hand" style="color: white;"
				        href="javascript:;" target="_blank"
				        onclick='Widget.EditorHeader.openNewWindow();'>
					    <i class="fa fa-share"></i></a>
				    </li>
					
					<!-- Repository -->
					<li><div id="setRepositoryAction" class="hand" 
					    onclick='Widget.EditorHeader.setRepository();'>
					    <i class="fa fa-eye"></i> <i class="fa fa-user"></i></div>
				    </li>
				    <li><a id="repositoryFileHistoryAction" class="hand" style="color: white;" 
				        href="javascript:;" target="_blank"
				        onclick='return Widget.EditorHeader.repositoryFileHistory();'>
					    <i class="fa fa-eye"></i> <i class="fa fa-file-o"></i></a>
				    </li>
				    <li><a id="repositoryStatusAction" class="hand" style="color: white;" 
				        href="javascript:;" target="_blank"
				        onclick='return Widget.EditorHeader.repositoryStatus();'>
					    <i class="fa fa-eye"></i> <i class="fa fa-folder-open"></i></a>
				    </li>
				    <li><div id="repositoryLogHistoryAction" class="hand"
				        onclick='return Widget.EditorHeader.repositoryLogHistory();'>
					    <i class="fa fa-eye"></i> <i class="fa fa-bars"></i></div>
				    </li>
				    <li><div id="repositoryCommitHistoryAction" class="hand"
				        onclick='Widget.EditorHeader.repositoryCommitHistory();'>
				        <i class="fa fa-eye"></i> <i class="fa fa-random"></i></div>
				    </li>
				    
					<!-- Create -->
					<li><div id="createFileAction" class="hand" 
					    onclick='Widget.EditorHeader.createFileName();'>
					    <i class="fa fa-plus"></i> <i class="fa fa-file-o"></i></div>
				    </li>
				    <li><div id="createDirectoryAction" class="hand" 
				        onclick='Widget.EditorHeader.createDirectoryName();'>
					    <i class="fa fa-plus"></i> <i class="fa fa-folder-open"></i></div>
					</li>
				    
				    <!-- Remove -->
					<li><div id="removeFileAction" class="hand" 
					    onclick='Widget.EditorHeader.removeFileName();'>
					    <i class="fa fa-minus"></i> <i class="fa fa-file-o"></i></div>
				    </li>
				    <li><div id="removeDirectoryAction" class="hand" 
				        onclick='Widget.EditorHeader.removeDirectoryName();'>
					    <i class="fa fa-minus"></i> <i class="fa fa-folder-open"></i></div>
				    </li>
					
					<!-- Rename -->
					<li><div id="renameFileAction" class="hand" 
					    onclick='Widget.EditorHeader.renameFileName();'>
					    <i class="fa fa-wrench"></i> <i class="fa fa-file-o"></i></div>
				    </li>
					<li><div id="renameDirectoryAction" class="hand" 
					    onclick='Widget.EditorHeader.renameDirectoryName();'>
					    <i class="fa fa-wrench"></i> <i class="fa fa-folder-open"></i></div>
					</li>
				    
				    <!-- Save -->
					<li><div id="saveAction" class="button special" 
					    onclick='Widget.EditorHeader.save();'>
				        Save</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.EditorHeader.prototype = {
	constructor: Widget.EditorHeader
}

Widget.EditorHeader.height = function () {
	return $('#header').height()
}


//
// login
//

Widget.EditorHeader.login = function () {
    var loginPopup = new Widget.TwoFieldsPopup({placeholder1: "Email", placeholder2: "Password", password: 2, proceed: function (emailGuid, passwordGuid) {
		var email = $("#" + emailGuid).val()
		var password = $("#" + passwordGuid).val()
		
		if (!isEmpty(email) && !isEmpty(password)) {
		    $.post(property.securityLoginUserUrl, {email: email, password: password})
        		.success(function (data) {
    		        Widget.successHandler(data)
    			})
    			.error(Widget.errorHandler)
    		
    		this.delete()
		} else {
		    this.delete()
		    var infoPopup = new Widget.InfoPopup({info: "Email and Password are required!"})
		}
	}})
}


//
// search
//

Widget.EditorHeader.search = function () {
    var directoryName = editor.homeDirectory || editor.directoryName
    
    if (isEmpty(directoryName)) {
        var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
        return false
    }
    
    var searchPopup = new Widget.EditorSearchPopup({proceed: function (proceedButtonGuid, queryGuid, replaceGuid, filterGuid, isRegexGuid, isFileNameGuid) {
		var query = $("#" + queryGuid).val()
		var replace = $("#" + replaceGuid).val()
		var filter = $("#" + filterGuid).val()
		var isRegex = $("#" + isRegexGuid).is(':checked')
		var isFileName = $("#" + isFileNameGuid).is(':checked')
		
		if (!isEmpty(query)) {
		    if (isEmpty(replace)) {
			    $("#" + proceedButtonGuid).attr("href", Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorSearchUrl, 
			        {
			            directoryName: encodeURIComponent(directoryName), 
			            query: encodeURIComponent(query), 
			            filter: encodeURIComponent(filter), 
			            isRegex: isRegex, 
			            isFileName: isFileName
			        }))
			} else {
			    $("#" + proceedButtonGuid).attr("href", Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorSearchUrl, 
			        {
			            directoryName: encodeURIComponent(directoryName), 
			            query: encodeURIComponent(query), 
			            replace: encodeURIComponent(replace), 
			            filter: encodeURIComponent(filter), 
			            isRegex: isRegex, 
			            isFileName: isFileName
			        }))
			}
    	} else {
            this.delete()
            
            var infoPopup = new Widget.InfoPopup({info: "query is required!"})
            return false
        }
	}})
}


//
// homeDirectory
//

Widget.EditorHeader.setHomeDirectory = function () {
	if (!isEmpty(editor.directoryName)) {
	    
	    var paths = editor.directoryName.split('/');
		var simpleDirectoryName = paths[paths.length - 1]
		
		var questionPopup = new Widget.QuestionPopup({question: "Set " + simpleDirectoryName + " as home directory?", proceed: function () {
    		var newSessionUrl = Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorDirectoryUrl, {d: encodeURIComponent(editor.directoryName)}, true)
    		
    		$.get(newSessionUrl)
    	        .success(function (dirs) {
            		var subdirs = new Widget.EditorNavigation(Widget.json(dirs), {path: editor.directoryName, name: simpleDirectoryName})
            		editorTemplate.setDirectoryNavigation(subdirs.html)
            		editor.homeDirectory = editor.directoryName
            		
            		$("#title").html(simpleDirectoryName)
            		$("#menu").html(simpleDirectoryName)
    			})
    			.error(Widget.errorHandler)
        	
        	this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select directory!"})
	}
}


//
// newWindow
//

Widget.EditorHeader.openNewWindow = function () {
    var directoryName = editor.homeDirectory || editor.directoryName
    
    if (!isEmpty(directoryName)) {
        var newSessionUrl = Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorHomeUrl, {directoryName: encodeURIComponent(directoryName)})
        
        $("#openNewWindowAction").attr("href", newSessionUrl)
    } else {
        var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
        return false
    }
}


//
// repository
//

Widget.EditorHeader.setRepository = function () {
    var repositoryPopup = new Widget.ThreeFieldsPopup({
        placeholder1: "Repository Name", 
        placeholder2: "User Name", 
        placeholder3: "Password", 
        password: 3,
        proceed: function (guid1, guid2, guid3) {
            var repository = $("#" + guid1).val()
    		var username = $("#" + guid2).val()
    		var password = $("#" + guid3).val()
    		
    		this.delete()
    		
    		if (!isEmpty(repository) && !isEmpty(username) && !isEmpty(password)) {
    		    vars.repository = {
    		        repository: repository,
    		        username: username,
    		        password: password
    		    }
    		    
    			var infoPopup = new Widget.InfoPopup({info: "repository set!"})
    		} else {
    		    var infoPopup = new Widget.InfoPopup({info: "repository, username and password are required!"})
    		}
	}}) 
}

Widget.EditorHeader.getRepository = function () {
    var repository
    if (vars.repository) {
        repository = vars.repository
    } else {
        repository = {
	        repository: getURLParameter("repository") || "",
	        username: getURLParameter("username") || "",
	        password: getURLParameter("password") || ""
	    }
    }
    
    return repository
}

Widget.EditorHeader.isRepositorySet = function () {
    var repository = Widget.EditorHeader.getRepository()
    
    return (!isEmpty(repository.repository) && !isEmpty(repository.username) && !isEmpty(repository.password))
}

Widget.EditorHeader.newSessionUrl = function (controller, data, noHiddenData) {
    var url = controller + "?session=new"
    
    if (noHiddenData) {
        // do not include hidden data
    } else {
        // include repository
        var repository = Widget.EditorHeader.getRepository() 
        for (var key in repository) {
            url += "&" + key + "=" + repository[key]
        }
    }
    
    for (var key in data) {
        url += "&" + key + "=" + data[key]
    }
    
    return url
}

Widget.EditorHeader.repositoryFileHistory = function () {
    var directoryName = editor.homeDirectory || editor.directoryName
    
    if (isEmpty(directoryName)) {
        directoryName = getURLParameter("directoryName")
    }
    
    var fileName = editor.fileName
    
    if (Widget.EditorHeader.isRepositorySet() && !isEmpty(fileName)) {
        var newSessionUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileHistoryUrl, {fileName: encodeURIComponent(fileName), directoryName: encodeURIComponent(directoryName)})
        
        $("#repositoryFileHistoryAction").attr("href", newSessionUrl)
    } else {
        var infoPopup = new Widget.InfoPopup({info: "repository and file are required!"})
        return false
    }
}

Widget.EditorHeader.repositoryStatus = function () {
    var directoryName = editor.homeDirectory || editor.directoryName
    
    if (Widget.EditorHeader.isRepositorySet() && !isEmpty(directoryName)) {
        var newSessionUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryStatusUrl, {directoryName: encodeURIComponent(directoryName)})
        
        $("#repositoryStatusAction").attr("href", newSessionUrl)
    } else {
        var infoPopup = new Widget.InfoPopup({info: "repository and directory are required!"})
        return false
    }
}

Widget.EditorHeader.repositoryLogHistory = function () {
    var directoryName = editor.homeDirectory || editor.directoryName
    
    if (Widget.EditorHeader.isRepositorySet() && !isEmpty(directoryName)) {
        var limitLogHistoryPopup = new Widget.OneFieldPopup({placeholder: "Number of revisions", proceed: function (guid) {
            var limit = $("#" + guid).val()
            
            var newSessionUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryLogHistoryUrl, {directoryName: encodeURIComponent(directoryName), limit: limit})
            
            $.get(newSessionUrl)
                .success(function (content) {
            		editor.fileName = null
            		Widget.EditorNavigation.selectFileName(null)
            		
            		editor.setValue(content)
            		editor.setMode("txt")
    			})
    			.error(Widget.errorHandler)
        	
            this.delete()
        }})
    } else {
        var infoPopup = new Widget.InfoPopup({info: "repository and directory are required!"})
        return false
    }
}

Widget.EditorHeader.repositoryCommitHistory = function () {
    if (getURLParameter("repository") == "SVN") {
        Widget.EditorHeader.repositoryCommitHistorySVN()
    } else if (getURLParameter("repository") == "GIT") {
        Widget.EditorHeader.repositoryCommitHistoryGIT()
    }
}

Widget.EditorHeader.repositoryCommitHistorySVN = function () {
    var directoryName = editor.homeDirectory || editor.directoryName
    
    if (Widget.EditorHeader.isRepositorySet() && !isEmpty(directoryName)) {
        var commitHistoryPopup = new Widget.TwoFieldsPopup({placeholder1: "New revision", placeholder2: "Old revision", proceed: function (newRevisionGuid, oldRevisionGuid) {
            var newRevision = $("#" + newRevisionGuid).val()
            var oldRevision = $("#" + oldRevisionGuid).val()
            
            this.delete()
            
            if (!isEmpty(newRevision) && !isEmpty(oldRevision)) {
                var newSessionUrl = Widget.EditorHeader.newSessionUrl(
                    property.repositoryUrl + property.repositoryCommitHistoryUrl, 
                    {directoryName: encodeURIComponent(directoryName), newRevision: newRevision, oldRevision: oldRevision})
                
                window.open(newSessionUrl)
            } else {
                var infoPopup = new Widget.InfoPopup({info: "new and old revisions is required!"})
            }
        }})
    } else {
        var infoPopup = new Widget.InfoPopup({info: "repository and directory are required!"})
        return false
    }
}

Widget.EditorHeader.repositoryCommitHistoryGIT = function () {
    var directoryName = editor.homeDirectory || editor.directoryName
    
    if (Widget.EditorHeader.isRepositorySet() && !isEmpty(directoryName)) {
        var commitHistoryPopup = new Widget.OneFieldPopup({placeholder: "Commit", proceed: function (guid) {
            var commit = $("#" + guid).val()
            
            this.delete()
            
            if (!isEmpty(commit)) {
                var newSessionUrl = Widget.EditorHeader.newSessionUrl(
                    property.repositoryUrl + property.repositoryCommitHistoryUrl, 
                    {directoryName: encodeURIComponent(directoryName), newRevision: commit})
                
                window.open(newSessionUrl)
            } else {
                var infoPopup = new Widget.InfoPopup({info: "commit number is required!"})
            }
        }})
    } else {
        var infoPopup = new Widget.InfoPopup({info: "repository and directory are required!"})
        return false
    }
}


//
// create/add
//

Widget.EditorHeader.createFileName = function () {
	if (!isEmpty(editor.directoryName)) {
		var createFileNamePopup = new Widget.OneFieldPopup({placeholder: "File Name", proceed: function (guid) {
			var name = $("#" + guid).val()
			if (!isEmpty(name)) {
				var paths = editor.directoryName.split('/');
				paths.push(name)
				$.get(Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorCreateFileUrl, {fileName: encodeURIComponent(paths.join('/'))}))
    				.success(function (data) {
    			        Widget.successHandler(data, name + " created!")
    				})
    				.error(Widget.errorHandler)
			}
			
			this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select parent directory!"})
	}
}

Widget.EditorHeader.createDirectoryName = function () {
	if (!isEmpty(editor.directoryName)) {
		var createDirectoryNamePopup = new Widget.OneFieldPopup({placeholder: "Directory Name", proceed: function (guid) {
			var name = $("#" + guid).val()
			if (!isEmpty(name)) {
				var paths = editor.directoryName.split('/');
				paths.push(name)
				$.get(Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorCreateDirectoryUrl, {directoryName: encodeURIComponent(paths.join('/'))})) 
    				.success(function (data) {
    			        Widget.successHandler(data, name + " created!")
    				})
    				.error(Widget.errorHandler)
			}
			
			this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select parent directory!"})
	}
}


//
// remove/delete
//

Widget.EditorHeader.removeFileName = function () {
	if (!isEmpty(editor.fileName)) {
		var fileName = editor.fileName
		
		var paths = editor.fileName.split('/');
		var simpleFileName = paths[paths.length - 1]
		
		var questionPopup = new Widget.QuestionPopup({question: "Delete " + simpleFileName + "?", proceed: function () {
			$.get(Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorRemoveUrl, {path: encodeURIComponent(fileName), isFile: "true"}))
    			.success(function (data) {
    		        Widget.successHandler(data, simpleFileName + " deleted!")
    		        
    	            $("#" + editor.fileGuid).hide()
    	            editor.fileName = null
    	            editor.fileGuid = null
    			})
    			.error(Widget.errorHandler)
			
			this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select file to delete!"})
	}
}

Widget.EditorHeader.removeDirectoryName = function () {
	if (!isEmpty(editor.directoryName)) {
		var directoryName = editor.directoryName
		
		var paths = editor.directoryName.split('/');
		var simpleDirectoryName = paths[paths.length - 1]
		
		var questionPopup = new Widget.QuestionPopup({question: "Delete " + simpleDirectoryName + "?", proceed: function () {
			$.get(Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorRemoveUrl, {path: encodeURIComponent(directoryName), isFile: "false"}))
			    .success(function (data) {
    				Widget.successHandler(data, simpleDirectoryName + " deleted!")
    			   	
    	            $("#" + editor.directoryGuid).parent().hide() // hide directory list element
    	            editor.directoryName = null
    	            editor.directoryGuid = null
    			})
    			.error(Widget.errorHandler)
			
			this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select directory to delete!"})
	}
}


//
// rename/move
//

Widget.EditorHeader.renameFileName = function () {
	if (!isEmpty(editor.fileName)) {
	    
	    var paths = editor.fileName.split('/');
		var simpleFileName = paths[paths.length - 1]
		
		var renameFileNamePopup = new Widget.OneFieldPopup({placeholder: "", value: simpleFileName, proceed: function (guid) {
			var name = $("#" + guid).val()
			if (!isEmpty(name)) {
			
				paths[paths.length - 1] = name
				
				$.get(Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorRenameUrl, {
				    oldName: encodeURIComponent(editor.fileName), 
				    newName: encodeURIComponent(paths.join('/')), 
				    directoryName: encodeURIComponent(editor.homeDirectory)
				}))
    				.success(function (data) {
    			        Widget.successHandler(data, simpleFileName + " renamed to " + name)
    				})
    				.error(Widget.errorHandler)
			}
			
			this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select file!"})
	}
}

Widget.EditorHeader.renameDirectoryName = function () {
	if (!isEmpty(editor.directoryName)) {
	    
	    var paths = editor.directoryName.split('/');
		var simpleDirectoryName = paths[paths.length - 1]
	    
		var renameDirectoryNamePopup = new Widget.OneFieldPopup({placeholder: "", value: simpleDirectoryName, proceed: function (guid) {
			var name = $("#" + guid).val()
			if (!isEmpty(name)) {
				
				paths[paths.length - 1] = name
				
				$.get(Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorRenameUrl, {
				    oldName: encodeURIComponent(editor.directoryName), 
				    newName: encodeURIComponent(paths.join('/')),
				    directoryName: encodeURIComponent(editor.homeDirectory)
				}))
    				.success(function (data) {
    			        Widget.successHandler(data, simpleDirectoryName + " renamed to " + name)
    				})
    				.error(Widget.errorHandler)
			}
			
			this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select directory!"})
	}
}


//
// save
//

Widget.EditorHeader.save = function () {
	if (!isEmpty(editor.fileName)) {
		var fileName = editor.fileName
		
		$.post(property.editorUrl + property.editorSaveUrl + "?f=" + encodeURIComponent(fileName), editor.getValue())
    		.success(function () {
    	        Widget.EditorHeader.saved(true)
    		})
    		.error(Widget.errorHandler)
	}
}

Widget.EditorHeader.saved = function (isSaved) {
    if (isSaved) {
        $("#saveAction").css("background-color", property.mainColor);
    } else {
        $("#saveAction").css("background-color", "red");
    }
}