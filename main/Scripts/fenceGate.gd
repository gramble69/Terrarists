extends Node3D
signal openedToggled

@onready var anim = $"../AnimationPlayer"
var opened = false

func toggleOpen():
	if opened == false:
		opened = true
		anim.play("open")
	else:
		opened = false
		anim.play("close")
	
