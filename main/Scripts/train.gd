extends Node3D
@onready var anim = $AnimationPlayer
@export var is_in_titlescreen: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_train_1_can_open_doors() -> void:
	anim.play("opendoors")
