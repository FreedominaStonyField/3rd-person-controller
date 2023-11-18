extends State
var player = Global.player
func enter():
	print("walk")
func update(delta):
	if Global.player.velocity.length() == 0:
		transition.emit("Idle")
#	if Input.is_action_just_pressed("ui_end"):
#		transition.emit("Idle")
