extends Node3D
signal hit
@export var enemy1 : Node3D

@onready var sound = $AudioStreamPlayer3D
var canShoot = true
@onready var anim = $AnimationPlayer
var spareAmmo = 36
var magazineAmmo = 18
var emptyMagSpace = 18 - magazineAmmo

var isShooting = false
#max magazine ammo is 18
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	magazineAmmo > -1
	if Engine.time_scale == 1:
		canShoot = true
	if Engine.time_scale == 0:
		canShoot = false
	if (CurrentPlayerScene.isBiengHeld == false):
		visible = false
		canShoot = false
	if (CurrentPlayerScene.isBiengHeld == true):
		anim.active = true
		visible = true
		canShoot = true
	if (CurrentPlayerScene.isBiengHeld == true && Input.is_action_just_pressed("shoot") && canShoot == true && Engine.time_scale == 1 && magazineAmmo > 0):
		sound.play(0)
		canShoot = false
		anim.play("shoot", -1, 2)
		magazineAmmo = magazineAmmo - 1
	if (CurrentPlayerScene.isBiengHeld == true && Input.is_action_just_released("shoot")):
		canShoot = true
		isShooting = false
	if(Input.is_action_just_pressed("reload")):
		spareAmmo = spareAmmo - emptyMagSpace
		magazineAmmo = 18
