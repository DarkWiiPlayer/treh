package = "treh"
version = "dev-1"
source = {
	url = "git+https://github.com/darkwiiplayer/treh"
}
description = {
	homepage = "https://github.com/darkwiiplayer/treh",
	license = "Unlicense"
}
dependencies = {
	"scaffold >= 1.3",
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
