extends RefCounted

const LANG = {
}

static func translate(key):
	return LANG[key] if LANG.has(key) else "";
	pass

