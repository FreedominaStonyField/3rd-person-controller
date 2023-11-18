extends State

@export var jump:float = 8

func enter():
	pass
func update(delta):
	pass
func physics_update(delta:float):
	Global.player.velocity.y = jump
	if Global.player.is_on_floor():
		transition.emit("Idle")
	else:
		transition.emit("Fall")
	pass
func exit():
	pass
