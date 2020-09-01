extends Node
class_name CreditsGenerator

var credits = []


static func get_credits(path: String = "res://") -> Array:
	var credits := []
	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				var subdir_path = "%s/%s" % [dir.get_current_dir(), file_name]
				credits += get_credits(subdir_path)
			if file_name.ends_with(".res") or file_name.ends_with(".tres"):
				var data = load("%s/%s" % [dir.get_current_dir(), file_name])
				if data is Credits:
					credits += data.credits
			file_name = dir.get_next()
		dir.list_dir_end()
	return credits


func _ready():
	credits = get_credits("res://")
	print(credits)


func get_musical_works() -> Array:
	var musical_works := []
	for work in credits:
		if work is MusicCredit:
			musical_works.append(work)
	return musical_works


func get_art_works() -> Array:
	var art_works := []
	for work in credits:
		if work is ArtCredit:
			art_works.append(work)
	return art_works


func get_sfx_works() -> Array:
	var sfx_works := []
	for work in credits:
		if work is SFXCredit:
			sfx_works.append(work)
	return sfx_works
