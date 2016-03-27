return {
	objects = {
		user = {
			admin = {
				email               =   "test@test.com", -- password is "test"
				passwordSalt        =   "sYrwUK0MS1QgIGzqPt3grVQM5+ycPaEUxzkPubTlqUs=",
				passwordHash        =   "ARyAML1JazvjrKc054GayA==",
			}
		},

		userPermission = {
			open = {code = "open"},

			read = {code = "read"},
			write = {code = "write"},

			execute = {code = "execute"},
			add = {code = "add"},
			remove = {code = "remove"},
			edit = {code = "edit"},
			save = {code = "save"},
			refresh = {code = "refresh"}
		},

		userGroup = {
			dbAdmin = {code = "dbAdmin"},
			codeEditor = {code = "codeEditor"}
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
			dbAdmin_refresh = {key = "dbAdmin", value = "refresh"}
		},

		["user.permissions-userPermission.users"] = {
			admin_open = {key = "admin", value = "open"}
		},

		["user.groups-userGroup.users"] = {
			admin_dbAdmin = {key = "admin", value = "dbAdmin"},
			admin_codeEditor = {key = "admin", value = "codeEditor"}
		}
	}
}