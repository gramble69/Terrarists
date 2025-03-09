extends RigidBody3D

var speed
var WALK_SPEED = 5.0 * 2
var SPRINT_SPEED = 8.0 * 2
var CROUCH_SPEED = WALK_SPEED / 2
var JUMP_VELOCITY = 4.8 * 2
var SENSITIVITY = 0.004
var isMoving = false

#bob variables
var BOB_FREQ = 2.4 / 2
var BOB_AMP = 0.08 / 2
var t_bob = 0.0

#fov variables
var BASE_FOV = 75.0
var FOV_CHANGE = 1.5 / 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var gun_holder = $Head/Camera3D/gunholder
@onready var handgun = $Head/Camera3D/gunholder/handgun
@onready var crosshair = $Head/Camera3D/TextureRect
@onready var pistolMagazineLabel = $Head/Camera3D/magazineLabel
@onready var pistolAmmoLabel = $Head/Camera3D/pistolAmmoLabel
@onready var ammoLabel = $Head/Camera3D/spareAmmoSeperater
@onready var anim = $AnimationPlayer


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		#gun_holder.rotate_x(event.relative.y * SENSITIVITY)
		#gun_holder.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		#gun_holder.rotate_y(-event.relative.x * SENSITIVITY)
		
func _process(delta: float) -> void:
	if (handgun.isBiengHeld == true):
		crosshair.visible = true
		pistolMagazineLabel.visible = true
		pistolAmmoLabel.visible = true
		ammoLabel.visible = true
	pistolMagazineLabel.text = str(handgun.magazineAmmo)
	pistolAmmoLabel.text = str(handgun.spareAmmo)


func _physics_process(delta):
	if isMoving == false:
		linear_damp = true
	else:
		linear_damp = false
	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		linear_velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	if Input.is_action_just_pressed("up"):
		linear_velocity = Vector3(0,0,!speed)
		isMoving = true
	else:
		isMoving = false
	if Input.is_action_just_pressed("down"):
		linear_velocity = Vector3(0,0,speed)
		isMoving = true
	else:
		isMoving = false
	if Input.is_action_just_pressed("left"):
		linear_velocity = Vector3(speed,0,0)
		isMoving = true
	else:
		isMoving = false
	if Input.is_action_just_pressed("right"):
		linear_velocity = Vector3(!speed,0,0)
		isMoving = true
	else:
		isMoving = false
	
	#crouch
	if (Input.is_action_just_pressed("crouch")):
		anim.play("crouch")
		
	if (Input.is_action_just_released("crouch")):
		anim.play_backwards("crouch")




func _on_handgun_pickup_area_entered(area: Area3D) -> void:
	get_parent().get_node("Map/handgun").queue_free()
	handgun.isBiengHeld = true
	handgun.position *= 0
