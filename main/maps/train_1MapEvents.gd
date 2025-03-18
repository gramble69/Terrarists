extends Node3D
signal canOpenDoors
@onready var anim = $mapEvent1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_map_events_animation_finished(anim_name: StringName) -> void:
	emit_signal("canOpenDoors")
