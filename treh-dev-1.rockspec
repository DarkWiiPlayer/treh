package = "treh"
version = "dev-1"
source = {
	url = "git+https://github.com/darkwiiplayer/treh"
}
description = {
	homepage = "https://github.com/darkwiiplayer/treh",
	license = "Unlicense"
}
build = {
	type = "builtin",
	modules = {
		treh = "src/treh.lua"
	},
	install = {
		bin = {
			"bin/treh"
		}
	}
}
