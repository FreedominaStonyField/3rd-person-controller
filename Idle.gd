extends State

@onready var player = Global.player
func enter():
	pass
func update(delta):
	pass
func physics_update(delta:float):
	
	if !Global.player.is_on_floor():
		transition.emit("Fall")
	
	
	if Input.is_action_pressed("ui_accept"):
		transition.emit("Jump")
	if Global.player.is_on_floor() and Input.get_vector("move_left", "move_right", "move_forward", "move_backward"):
		transition.emit("Walk")
	pass
func exit():
	pass
