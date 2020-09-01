extends SceneTree
# This script can be run from the command line using:
# godot -s generate_license_files.gd
# It will recursively search the res:// directory for files named credits.tres
# and create a corresponding licenses.txt file to be placed along side it.


func list_directories(path: String = "res://") -> Array:
	var directories := [path]
	var dir := Directory.new()
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				var subdir_path = "%s/%s" % [dir.get_current_dir(), file_name]
				directories += list_directories(subdir_path)
			file_name = dir.get_next()
		dir.list_dir_end()
	return directories


func format_person(person: PersonCredit) -> String:
	if person.name and person.nickname:
		return "%s (%s)" % [person.name, person.nickname]
	elif person.nickname:
		return person.nickname
	elif person.name:
		return person.name
	else:
		return "[Unknown]"


func people_credits(people: Array) -> String:
	var credits := PoolStringArray([])
	for person in people:
		if person.url:
			credits.append("[%s](%s)" % [format_person(person), person.url])
		else:
			credits.append(format_person(person))
	return credits.join(", ")


func get_credits_markdown(credits: Array, credits_path: String,
		indent: String = "") -> String:
	var markdown := "" if indent.length() > 0 else \
			"<!--- Do not modify this file! It was generated from credits.tres --->\n"
	
	for i in range(credits.size()):
		var credit: WorkCredit = credits[i]
		
		var title: String = credit.title if credit.title else "[Untitled]"
		var source = credit.sources[0] if not credit.sources.empty() else null
		if title and source:
			title = "[%s](%s)" % [title, source]
		if indent.length() > 0:
			markdown += "%s- ### %s  \n" % [" ".repeat(indent.length() / 2), title]
		else:
			markdown += "\n### %s  \n" % title
		
		if not credit.authors.empty():
			var people_credits = people_credits(credit.authors)
			markdown += "%s**Authors**: %s  \n" % [indent, people_credits]
		
		if credit is MusicCredit:
			if not credit.writers.empty():
				markdown += "%s**Writers**: %s  \n" % [indent, people_credits(credit.writers)]
			if not credit.composers.empty():
				markdown += "%s**Composers**: %s  \n" % [indent, people_credits(credit.composers)]
			if not credit.lyricists.empty():
				markdown += "%s**Lyrics**: %s  \n" % [indent, people_credits(credit.lyricists)]
			if not credit.performers.empty():
				markdown += "%s**Performers**: %s  \n" % [indent, people_credits(credit.performers)]
		
		if not credit.other_contributors.empty():
			markdown += "%s**Contributors**: %s  \n" % [indent, people_credits(credit.other_contributors)]
		
		if not credit.commissioners.empty():
			markdown += "%s**Commissioners**: %s  \n" % [indent, people_credits(credit.commissioners)]
		
		if not credit.licenses.empty():
			var licenses := PoolStringArray([])
			for license in credit.licenses:
				if license.id and license.url:
					licenses.append("[%s](%s)" % [license.id, license.url])
				else:
					licenses.append(license.id)
			markdown += "%s**Licenses**: %s  \n" % [indent, licenses.join(", ")]
		
		if not credit.files.empty():
			var files := PoolStringArray([])
			for file in credit.files:
				var file_path = file.get_path() if not file is String else \
						"%s%s" % [credits_path.replace("credits.tres", ""), file]
				file_path = file_path.replace("res://", "/")
				var file_name = file_path.split("/")[-1]
				files.append("[%s](%s)" % [file_name, file_path])
			markdown += "%s**Files**: %s  \n" % [indent, files.join(", ")]
		
		if not credit.notes.empty():
			markdown += "%s**Notes**: %s  \n" % [indent, credit.notes]
		
		if not credit.derived_from.empty():
			markdown += "%s**Derived from**:  \n" % [indent]
			markdown += get_credits_markdown(credit.derived_from, credits_path, indent + "    ")
	
	return markdown


func generate_licenses_file(path: String):
	var credits_file := File.new()
	var credits_path := "%s/credits.tres" % path
	
	if not credits_file.file_exists(credits_path):
		return
	
	var credits_data: Credits = load(credits_path)
	var licenses_file := File.new()
	var markdown = get_credits_markdown(credits_data.credits, credits_path)
	
	licenses_file.open("%s/licenses.md" % path, File.WRITE)
	licenses_file.store_string(markdown)
	licenses_file.close()


func _init():
	for directory in list_directories():
		generate_licenses_file(directory)
	quit()
