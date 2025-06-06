extends Node3D

@onready var mainTheme = $AudioStreamPlayer3D

func _ready() -> void:
	mainTheme.play(0.0)
