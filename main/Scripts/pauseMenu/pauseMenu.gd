extends Control


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pauseMenu") && visible == false:
		visible = true
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_resume_pressed() -> void:
	visible = false
	Engine.time_scale = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_main_menu_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://maps/titleScreens/titleScreen1.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit(0)
