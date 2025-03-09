extends Camera3D
@onready var handgun = $gunholder/handgun
@onready var pauseMenu = $PauseMenu
@onready var gasMask = $GasMask
@onready var gasMaskLabel = $VBoxContainer/gasMaskLabel
signal gasMaskIsOn
signal gasMaskIsOff
var gasMaskOn = false
var rayRange = 2000
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gasMask.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot") && Engine.time_scale == 1 && handgun.magazineAmmo > 0:
		getCameraCollision()
	if Input.is_action_just_pressed("toggleGasMaskOn"):
		gasMaskLabel.text = "on"
		gasMask.visible = true
		emit_signal("gasMaskIsOn")
	if Input.is_action_just_pressed("toggleGasMaskOff"):
		gasMaskLabel.text = "off"
		gasMask.visible = false
		emit_signal("gasMaskIsOff")
func getCameraCollision():
	var center = get_viewport().get_size() / 2
	var rayOrigin = project_ray_origin(center)
	var rayEnd = rayOrigin + project_ray_normal(center) * rayRange
	var newIntersection = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var intersection = get_world_3d().direct_space_state.intersect_ray(newIntersection)
	if not intersection.is_empty():
		print(intersection.collider.name)
		if intersection.collider.name == "enemy" :
			intersection.collider.health = intersection.collider.health - 25
		else:
			print("nothing")
	else:
		print("nothing")
func gasMaskToggle():
	if gasMaskOn == false:
		gasMask.visible = true
		print("gas mask on")
		gasMaskOn = true
	if gasMaskOn == true:
		gasMask.visible = false
		print("gas mask off")
		#gasMaskLabel.text = "off"
		gasMaskOn = false


func _on_player_current_camera_true() -> void:
	current = true
