class_name PlayerIdleState
extends State

@onready var player = Global.player

func update(delta):
	if Global.player.velocity.length() > 0:
		print(Global.player.velocity.length())
		transition.emit()
	pass
