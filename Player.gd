extends CharacterBody3D

@export var animation_player:AnimationPlayer
@export var camera_rig:Node3D
@export var max_step_height:float = floor_snap_length + .1
@export var invert_mouse:bool = true
@export var walk_animation: String
@export var run_animation: String
@export var idle_animation: String




@onready var visuals = $Visuals
@onready var footstep_aui :AudioStreamPlayer3D= $AudioStreamPlayer3D

@export_range(0.01, 1, 0.01) var look_horazontal_sensitivety: float 
@export_range(0.01, 1, 0.01) var look_vertical_sensitivety: float 
@export_range(0.01, 2, 0.01) var walking_speed: float 
@export_range(0.02, 10, 0.01) var running_speed: float 

var SPEED = 1.0
var running: bool
var is_locked:bool
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.player = self

func _input(event):
	if event is InputEventMouseMotion:
		if invert_mouse:
			rotate_y(deg_to_rad(event.relative.x * look_horazontal_sensitivety))
			visuals.rotate_y(deg_to_rad(-event.relative.x * look_horazontal_sensitivety))
			camera_rig.rotate_x(deg_to_rad(-event.relative.y * look_vertical_sensitivety))
		else:
			rotate_y(deg_to_rad(-event.relative.x * look_horazontal_sensitivety))
			visuals.rotate_y(deg_to_rad(event.relative.x * look_horazontal_sensitivety))
			camera_rig.rotate_x(deg_to_rad(event.relative.y * look_vertical_sensitivety))

func _physics_process(delta):
	

#	if !animation_player.is_playing():
#		is_locked = false
	
#	if Input.is_action_just_pressed("emote"):
#		is_locked = true
#		if animation_player.current_animation != "t-pose":
#			animation_player.play("t-pose")
		
	# Check if running
	if Input.is_action_pressed("sprint"):
		running = true
		SPEED = running_speed
	else:
		running = false
		SPEED = walking_speed
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if is_on_wall() and is_on_floor():
#			set_global_position($RayCast3D.get_collision_point())

			snap_to_top_of_step()


		# look in the direction the player is moving toward
		if !is_locked:
			visuals.rotation.y = lerp_angle(visuals.rotation.y, atan2(-input_dir.x, -input_dir.y),.1)
#			visuals.look_at(position + direction)
		#check if running
			if running:
			# play running animation
				if run_animation:
					if animation_player.current_animation != run_animation:
						animation_player.play(run_animation)
			
			else:
			# else play the walking animation
				if walk_animation:
					if animation_player.current_animation != walk_animation:
						animation_player.play(walk_animation)
			
		# set the volicity to match the derection and multiply it to get the speed the character is moving
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player:
			if !is_locked:
				if animation_player.current_animation != idle_animation:
					animation_player.play(idle_animation)
			
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if !is_locked:
		move_and_slide()

func play_footstep():
	if is_on_floor():
		footstep_aui.pitch_scale = randf_range(.8,1.2)
		footstep_aui.play()


func snap_to_top_of_step():
	print("snap_to_top_of_step()")
	if not $WallDetector.is_colliding():
		position.y += max_step_height
