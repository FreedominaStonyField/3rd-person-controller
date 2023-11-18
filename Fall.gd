extends State

@export var gravity:float = 10
@export var air_speed:float = 3
func enter():
	pass
func update(delta):
	pass
func physics_update(delta:float):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (Global.player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		
		#set the models to face the right direction.
#		visuals.look_at(Global.player.position + direction)
		#Moeves the player
		Global.player.velocity.x = direction.x * air_speed
		Global.player.velocity.z = direction.z * air_speed
	if not Global.player.is_on_floor():
		Global.player.velocity.y -= gravity * delta
	else:
		
		Global.player.velocity.x = move_toward(Global.player.velocity.x, 0, delta)
		Global.player.velocity.z = move_toward(Global.player.velocity.z, 0, delta)
		if Global.player.velocity.length() == 0:
			transition.emit("Idle")
		else:
			transition.emit("Walk")
func exit():
	pass
