extends State


@export_range(0.01, 10, 0.01) var walking_speed: float 
@export var visuals:Node3D

func enter():
	pass
func update(delta):
	pass
func physics_update(delta:float):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (Global.player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	
	if !Global.player.is_on_floor():
		transition.emit("Fall")
	if direction:
		if Global.player.is_on_wall() and Global.player.is_on_floor():
			print("snap to ledge")
			Global.player.snap_to_top_of_step()
		#set the models to face the right direction.
		visuals.rotation.y = lerp_angle(visuals.rotation.y, atan2(-input_dir.x, -input_dir.y),.1)
#		visuals.look_at(Global.player.position + direction)
		#Moeves the player
		Global.player.velocity.x = direction.x * walking_speed
		Global.player.velocity.z = direction.z * walking_speed
	else :
		Global.player.velocity.x = move_toward(Global.player.velocity.x, 0, Global.player.SPEED)
		Global.player.velocity.z = move_toward(Global.player.velocity.z, 0, Global.player.SPEED)
	if Global.player.velocity.length() == 0:
		transition.emit("Idle")
	
	if Input.is_action_just_pressed("ui_accept"):
		transition.emit("Jump")

func exit():
	pass
