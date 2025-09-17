extends Area3D

@onready var delay = $Timer
@onready var yourNotSupposedToBeHere = $AudioStreamPlayer

var delayStarted

func _on_player_entered_alley_way() -> void:
	print("delayStarted")
	delay.start()
	delayStarted = true

#func _process(delta: float) -> void:
#	if (delayStarted == true):
#		if (delay.time_left == 0.01):
#			print("delayFinished")
#			yourNotSupposedToBeHere.play(0.0)
# that is bassicly what the _on_timer_timeout function does

func _on_timer_timeout() -> void:
	print("delayFinished")
	yourNotSupposedToBeHere.play(0.0)
