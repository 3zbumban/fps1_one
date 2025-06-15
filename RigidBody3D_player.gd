extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
		# Add the gravity.
	pass
	#_hanlde_crouch()
	##_draw_crosshair()
	#
	#
	##if Input.is_action_just_pressed("shoot"):	
		##_shoot()
	#
	##if _is_head_coliding():
		##print("head is colliding")
	#
	##if not is_on_floor():
		##self.velocity.y -= (gravity * delta) * fall_acl
		##self.velocity.y = clamp(self.velocity.y, -100, JUMP_VELOCITY)
		##
	## Handle jump.
	##if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		##velocity.y = JUMP_VELOCITY
		#
	#var input_dir = Input.get_vector("move_l", "move_r", "move_b", "move_f")
	#var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#self.direction = dir
	#self.direction = lerp(self.direction, dir, 10.0)
	#
	#if self.crouching:
		#self.current_speed = self.crouch_speed
	#
	#if self.sprinting:
		#self.current_speed = self.sprint_speed
	#else:
		#self.current_speed = self.speed
	#
	#if self.direction:
		#self.velocity.x = self.direction.x * self.current_speed
		#self.velocity.z = self.direction.z * self.current_speed
	#else:
		#self.velocity.x = move_toward(velocity.x, 0, self.current_speed)
		#self.velocity.z = move_toward(velocity.z, 0, self.current_speed)
	#
	#Global.debug_data.dir = self.direction
	#Global.debug_data.vel = self.velocity
	#Global.debug_data.cam_dir = $head/pivot.rotation
	#Global.debug_data.player_rotation = self.rotation
	#Global.debug_data.player_basis = self.basis	
	#
	#check_steps()
	#move_and_slide()
	#var tmp_pos = self.position
	#var tmp_vel = self.velocity
	#check_and_apply_push()
	#self.position = tmp_pos
	#self.velocity = tmp_vel
