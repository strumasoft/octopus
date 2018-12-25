return {
	objects = {
		userPermission = {
			open = {code = "open"},

			read = {code = "read"},
			write = {code = "write"},

			execute = {code = "execute"},
			add = {code = "add"},
			remove = {code = "remove"},
			edit = {code = "edit"},
			save = {code = "save"},
			refresh = {code = "refresh"},
		},

		userGroup = {
			dbAdmin = {code = "dbAdmin"},
			codeEditor = {code = "codeEditor"},
		}
	},

	relations = {
		["userGroup.permissions-userPermission.groups"] = {
			codeEditor_read = {key = "codeEditor", value = "read"},
			codeEditor_write = {key = "codeEditor", value = "write"},

			dbAdmin_execute = {key = "dbAdmin", value = "execute"},
			dbAdmin_add = {key = "dbAdmin", value = "add"},
			dbAdmin_remove = {key = "dbAdmin", value = "remove"},
			dbAdmin_edit = {key = "dbAdmin", value = "edit"},
			dbAdmin_save = {key = "dbAdmin", value = "save"},
			dbAdmin_refresh = {key = "dbAdmin", value = "refresh"},
		},
	}
}