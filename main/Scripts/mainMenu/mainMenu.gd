extends Control
#sandboxLevel = load("res://Scenes/World.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_sandbox_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_play_regular_pressed() -> void:
	get_tree().change_scene_to_file("res://maps/train_1.tscn")
