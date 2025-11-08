extends CharacterBody3D
signal currentCameraTrue
signal enteredAlleyWay
@export var isInWakeUpAnim:bool
@export var currentCamera:bool
var speed
var gasMaskIsOn = false
@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 8.0
var CROUCH_SPEED = WALK_SPEED / 2
@export var JUMP_VELOCITY = 4.8 
var SENSITIVITY = 0.004
var isSwimming: bool

#bob variables
var BOB_FREQ = 2.4 / 2
var BOB_AMP = 0.25 / 2
var t_bob = 0.0

#fov variables
var BASE_FOV = 75.0
var FOV_CHANGE = 1.5 / 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8
@onready var playerCollision = $player_collision
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var gun_holder = $Head/Camera3D/gunholder
@onready var handgun = $Head/Camera3D/gunholder/handgun
@onready var crosshair = $Head/Camera3D/TextureRect
@onready var pistolMagazineLabel = $Head/Camera3D/magazineLabel
@onready var pistolAmmoLabel = $Head/Camera3D/pistolAmmoLabel
@onready var ammoLabel = $Head/Camera3D/spareAmmoSeperater
@onready var anim = $AnimationPlayer
@onready var ouch = $AudioListener3D/AudioStreamPlayer3D
@onready var toBeContinued = $Control
@onready var footStepSound = $footStep/AudioStreamPlayer3D

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
	if (currentCamera == true):
		emit_signal("currentCameraTrue")


func _physics_process(delta):
	# Add the gravity.
	if isSwimming == true:
		gravity = gravity/4
	if isSwimming == false: gravity = gravity
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and isSwimming == false:
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			#$footStep/Timer.start()
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
			#$footStep/Timer.start()
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()
	#crouch
	if (Input.is_action_just_pressed("crouch")):
		anim.play("crouch")
		
	if (Input.is_action_just_released("crouch")):
		anim.play_backwards("crouch")
	
	#foot steps
	if Input.is_action_just_pressed("up"):
		$footStep/Timer.start()
		footStepSound.play()
		#print("making foot step sound")
	if Input.is_action_just_released("up"):
		$footStep/Timer.stop()
		footStepSound.play()
	
	if Input.is_action_just_pressed("down"):
		$footStep/Timer.start()
		footStepSound.play()
		#print("making foot step sound")
	if Input.is_action_just_released("down"):
		$footStep/Timer.stop()
		footStepSound.play()
	
	if Input.is_action_just_pressed("right") && not Input.is_action_just_pressed("left"):
		$footStep/Timer.start()
		footStepSound.play()
		#print("making foot step sound")
	if Input.is_action_just_released("right") && not Input.is_action_just_pressed("left"):
		$footStep/Timer.stop()
		footStepSound.play()
	
	if Input.is_action_just_pressed("left") && not Input.is_action_just_pressed("right"):
		$footStep/Timer.start()
		footStepSound.play()
		#print("making foot step sound")
	if Input.is_action_just_released("left") && not Input.is_action_just_pressed("right"):
		$footStep/Timer.stop()
		footStepSound.play()
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func _on_handgun_area_area_entered(area: Area3D) -> void:
	get_parent().get_node("Map/handgun").queue_free()
	handgun.isBiengHeld = true




func _on_camera_3d_gas_mask_is_on() -> void:
	gasMaskIsOn = true


func _on_camera_3d_gas_mask_is_off() -> void:
	gasMaskIsOn = false


func _on_area_3d_area_entered(area: Area3D) -> void:
	if gasMaskIsOn == false:
		ouch.play()
	if gasMaskIsOn == true:
		pass


func OnEnteredAlleyWay(area: Area3D) -> void:
	emit_signal("enteredAlleyWay")


func _on_area_3d_body_entered(body: Node3D) -> void:
	toBeContinued.visible = true


func onNextFootStep() -> void:
	footStepSound.play()
