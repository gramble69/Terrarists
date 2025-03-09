extends Node3D
signal hit
var group = "enemy"
var health = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health == 0:
		queue_free()


func _on_signal_hit_emited() -> void:
	health = health - 25
