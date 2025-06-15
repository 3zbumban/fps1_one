extends CharacterBody3D

@export var speed = 7.8
@export var sprint_speed = 12.8
@export var crouch_speed = 4.8
@export var crouch_animation_speed = 0.25
@export var fall_acl = 1.2
@export var JUMP_VELOCITY: float =  4.5
@export var mouse_sense: float = 0.1337
#@export var push_force: float = 14.2
@onready var step1: RayCast3D = $RayCast3D_step1
@onready var fps_cam: Camera3D = $head/pivot/Camera3D
@onready var trd_person_cam: Camera3D = $head/pivot/trd_person_cam

var current_speed = 4.0
var target_velo = Vector3.ZERO
var direction = Vector3.ZERO
var crouching = false
var sprinting = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

signal hit
signal player_col

@onready var HUD = $hud
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var head_shapecast: ShapeCast3D = $head/ShapeCast3D
@onready var rigid_body: RigidBody3D = $RigidBody3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

#class PlayerAutomaton:
	#const state_table = {
		#walk: 
	#}
	#
	#PlayerAutomaton():
		#

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	head_shapecast.add_exception(self)
	animation_player.speed_scale = crouch_animation_speed
	self.collision_shape = collision_shape
	#self.rigid_body.add_child(collision_shape)

func _input(event):
	if event is InputEventMouseMotion:
		#print(event.relative)
		self.rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		var camrotation = deg_to_rad(event.relative.y * mouse_sense)
		$head/pivot.rotate_x(camrotation)
		$head/pivot.rotation.x = clamp($head/pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89)) 
		#rotate_x(event.relative.x * mouse_sense)		
	if event.is_action_pressed("quit"):
		self.get_tree().quit(0)
		
	if event.is_action("crouch"):
		if event.is_pressed():
			self.crouching = true
		elif event.is_released():
			self.crouching = false
	
	if event.is_action("sprint"):
		#print("sprinting")
		if event.is_pressed() and not self.crouching:
			self.sprinting = true
		elif event.is_released():
			self.sprinting = false
		else:
			self.sprinting = false
		#print(self.sprinting)

func _is_head_coliding():
	return head_shapecast.is_colliding()

func check_steps():
	#var foot_pos = self.position.y - 0.5
	#var pos = self.position
	#if self.step1.is_colliding():
		#
		#print("can_step %s" % foot_pos)
		#draw_step()
		#var box = ThreeDraw.new().draw_box(self.step1.target_position)
		#self.add_child(box)
		#self.get_tree().create_timer(0.5).timeout.connect(func():
			#box.queue_free()
		#)
	pass

func draw_step():
	
	pass

func check_and_apply_push():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody3D:
			var push_dir = -collision.get_normal()
			var collision_normal = collision.get_normal()
			const MY_APPROX_MASS_KG = 80.0
			var mass_ratio = min(1., MY_APPROX_MASS_KG / collision.get_collider().mass)
			var push_force: float = mass_ratio * 5.0
			var velocity_diff_in_push_dir = self.velocity.dot(push_dir) - collision.get_collider().linear_velocity.dot(push_dir)
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			var is_side_collision = abs(collision_normal.dot(Vector3.UP)) < 0.75
			# How much velocity the object needs to increase to match player velocity in the push direction
			# Only count velocity towards push dir, away from character
			# Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			# Optional add: Don't push object at all if it's 4x heavier or more
			#if mass_ratio < 0.25:
				#continue
			# Don't push object from above/below
			push_dir.y = 0
			# 5.0 is a magic number, adjust to your needs
			#var push_force: float = 5		
			#collision.get_collider().apply_force(, )
			var col_angle = collision.get_angle()
			var col_veocity = collision.get_collider_velocity()
			var col_position = collision.get_position()
			var relative_velocity = collision.get_collider_velocity() - self.get_velocity()
			var col_mass = collider.mass
			var player_dir = Global.debug_data.dir
			
			var col_position_v2 = collision.get_position() - collision.get_collider().global_position
			var force_vector_v2 = push_dir * velocity_diff_in_push_dir * push_force
			
			var force_vector = collision_normal * 1 * col_mass * -push_force + player_dir
			if not relative_velocity.is_zero_approx():
				force_vector = collision_normal * relative_velocity.length() * col_mass * -push_force + player_dir
			
			#var force_position = col_position - collider.global_transform.origin
			var force_position = (collider.global_transform.origin - self.global_transform.origin).normalized()			


			#var force_vector = collision_normal * -push_force  # Push force should be in the opposite direction of the collision normal
			#var impulse = collision_normal * force # * relative_velocity.length()			

			if is_side_collision:
				#collider.apply_central_force(force_vector)
				#collider.apply_force(force_vector, force_position)
				collider.apply_force(force_vector_v2, col_position_v2)
				self.emit_signal("player_col", {"force_vector": force_vector_v2, "force_position": force_position, "col_position": col_position})
				#collider.apply_force(force_vector, col_position)
				#print("Info: Applying push force to %s" % collider)
				print("%s %s" %[force_vector, col_position])
			else:
				print("Info: not a sinde collision")

func _hanlde_crouch():
	#print("crouching = %s" % self.crouching)
	
	if self.crouching:
		animation_player.play("crouch", 1, 50)
	elif self.crouching == false and _is_head_coliding() == false:
		animation_player.play("crouch", 1, -50)
	pass
	#self.crouching = false	

func _draw_crosshair():
	var screen_center = get_viewport().size / 2
	var hud_center = $hud.get_rect().size / 2
	Global.debug_data.screen_center = screen_center
	Global.debug_data.hud_center = hud_center
	$hud.screen_center = screen_center
	#$hud.request_ready()
	#$hud.draw_circle(Vector2(100,100), 10.0, Color.RED)
	#$hud.draw_circle(hud_center, 3.0, Color.WEB_PURPLE)
	#$hud.draw_line(Vector2(0,0), get_viewport().size)
	$hud.queue_redraw()
	pass

func _process(delta):
	#_draw_crosshair()
	pass

func _shoot():
	var space_state = get_world_3d().direct_space_state
	var cam = $head/pivot/Camera3D
	var mousepos = get_viewport().get_mouse_position()
	var RAY_LENGTH = 100.0

	var origin = cam.project_ray_origin(mousepos)
	#var origin = cam.project_ray_origin(mousepos)
	#var screen_center = get_viewport().size / 2
	#var origin = 
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end, 0xffffff , [self])
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	
	if result.size() > 0:
		#var label = Label3D.new()
		#label.position = result.position
		#
		#label.position.y = label.position.y
		#label.text = "hit"
		#for res in result:
			#res.add_child(label)
		Global.debug_data.last_ray = result
		emit_signal("hit", {"position": position, "result": result})
	#print(result)

func _physics_process(delta):
		# Add the gravity.
	_hanlde_crouch()
	_draw_crosshair()
	
	
	if Input.is_action_just_pressed("shoot"):	
		_shoot()
	
	if _is_head_coliding():
		print("head is colliding")
	
	if not is_on_floor():
		self.velocity.y -= (gravity * delta) * fall_acl
		self.velocity.y = clamp(self.velocity.y, -100, JUMP_VELOCITY)
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir = Input.get_vector("move_l", "move_r", "move_b", "move_f")
	var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	self.direction = dir
	self.direction = lerp(self.direction, dir, 10.0)
	
	if self.crouching:
		self.current_speed = self.crouch_speed
	
	if self.sprinting:
		self.current_speed = self.sprint_speed
	else:
		self.current_speed = self.speed
	
	if self.direction:
		velocity.x = self.direction.x * self.current_speed
		velocity.z = self.direction.z * self.current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, self.current_speed)
		velocity.z = move_toward(velocity.z, 0, self.current_speed)
	
	Global.debug_data.dir = self.direction
	Global.debug_data.vel = self.velocity
	Global.debug_data.cam_dir = $head/pivot.rotation
	Global.debug_data.player_rotation = self.rotation
	Global.debug_data.player_basis = self.basis	
	
	check_steps()
	check_and_apply_push()
	#_push_away_rigid_bodies()
	move_and_slide()
	#var tmp_pos = self.position
	#var tmp_vel = self.velocity
	#self.position = tmp_pos
	#self.velocity = tmp_vel

# CC0/public domain/use for whatever you want no need to credit
# Call this function directly before move_and_slide() on your CharacterBody3D script
func _push_away_rigid_bodies():
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir = -c.get_normal()
			# How much velocity the object needs to increase to match player velocity in the push direction
			var velocity_diff_in_push_dir = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			# Only count velocity towards push dir, away from character
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			# Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			const MY_APPROX_MASS_KG = 80.0
			var mass_ratio = min(1., MY_APPROX_MASS_KG / c.get_collider().mass)
			# Optional add: Don't push object at all if it's 4x heavier or more
			if mass_ratio < 0.25:
				continue
			# Don't push object from above/below
			push_dir.y = 0
			# 5.0 is a magic number, adjust to your needs
			var push_force = mass_ratio * 5.0
			c.get_collider().apply_force(push_dir * velocity_diff_in_push_dir * push_force, c.get_position() - c.get_collider().global_position)
