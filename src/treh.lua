--- Prints a tree-view of a directory

local scaffold = require 'scaffold'

local treh = {}

local function recurse(tree, buffer, prefix, filter, color)
	local names = {}
	for name in pairs(tree) do
		if filter(name) then
			table.insert(names, name)
		end
	end
	table.sort(names)
	for idx, name in pairs(names) do
		local item = tree[name]
		local last = idx==#names
		local pipe = color('pipes', last and "└─ " or "├─ ")
		table.insert(buffer, prefix .. pipe .. color(item==true and 'files' or 'directories', name))
		if type(item) == "table" then
			recurse(item, buffer, prefix .. color('pipes', last and "   " or "│  "), filter, color)
		end
	end
	return buffer
end

local default_colors = {
	files = "\x1b[32m";
	directories = "\x1b[33m";
	root = "\x1b[35m";
	pipes = "\x1b[37m";
}

local function colors(lookup)
	if lookup then
		return function(name, str)
			local prefix = lookup[name]
			if prefix then
				return lookup[name] .. str .. "\x1b[0m"
			else
				return str
			end
		end
	else
		return function(_, str) return str end
	end
end

local function filter(patterns, name)
	for pattern, plain in pairs(patterns) do
		if name:find(pattern, 1, plain) then
			return false
		end
	end
	return true
end

local function buildfilter(options)
	local patterns = {}
	if options.nogit then
		patterns[".git"] = true
	end
	if options.notup then
		patterns["Tupfile"] = true
		patterns["Tupfile.ini"] = true
		patterns[".tup"] = true
	end
	if options.ignore then
		for _, pattern in ipairs(options.ignore) do
			patterns[pattern] = false
		end
	end
	return function(name)
		return filter(patterns, name)
	end
end

function treh.dir(path, options)
	path = path or '.'
	local tree = scaffold.readdir(path, {files=true, hidden=options.hidden})

	local color = options.color and colors(default_colors) or colors()

	local lines = recurse(tree, {color('root', path)}, '', buildfilter(options), color)

	print(table.concat(lines, "\n"))
end

function treh.paths(paths, options)
	local tree = {}
	for path in pairs(paths) do
		scaffold.deep(tree, path, true)
	end
	local color = options.color and colors(default_colors) or colors()
	local lines = recurse(tree, {}, '', buildfilter(options), color)
	print(table.concat(lines, "\n"))
end

return treh
