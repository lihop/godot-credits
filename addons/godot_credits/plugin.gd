tool
extends EditorPlugin


func get_name():
	return "Godot Credits"


func _enter_tree():
	if not ProjectSettings.has_setting("godot_credits/path_prefix"):
		ProjectSettings.set_setting("godot_credits/path_prefix", "/")
	
	add_custom_type("CreditsGenerator", "Node",
			preload("./credits_generator.gd"), null)


func _exit_tree():
	remove_custom_type("CreditsGenerator")
