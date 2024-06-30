extends CharacterBody3D

@export var speed = 7.8
@export var crouch_speed = 4.8
@export var fall_acl = 75
@export var JUMP_VELOCITY =  4.5
@export var mouse_sense = 0.1337

signal hit

var target_velo = Vector3.ZERO
var direction = Vector3.ZERO
var crouching = false


@onready var HUD = $hud

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#class PlayerAutomaton:
	#const state_table = {
		#walk: 
	#}
	#
	#PlayerAutomaton():
		#


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$head/ShapeCast3D.add_exception(self)

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

func _is_head_coliding():
	return $head/ShapeCast3D.is_colliding()

func _hanlde_crouch():
	#print("crouching = %s" % self.crouching)
	
	if self.crouching:
		$AnimationPlayer.play("crouch", 1, 50)
	elif self.crouching == false and _is_head_coliding() == false:
		$AnimationPlayer.play("crouch", 1, -50)
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
	var query = PhysicsRayQueryParameters3D.create(origin, end)
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
		velocity.y -= gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir = Input.get_vector("move_l", "move_r", "move_b", "move_f")
	var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	self.direction = dir
	self.direction = lerp(self.direction, dir, 10.0)
	
	var sp = self.speed
	if self.crouching:
		sp = self.crouch_speed
	
	if self.direction:
		velocity.x = self.direction.x * sp
		velocity.z = self.direction.z * sp
	else:
		velocity.x = move_toward(velocity.x, 0, sp)
		velocity.z = move_toward(velocity.z, 0, sp)
	
	Global.debug_data.dir = self.direction
	Global.debug_data.vel = velocity
	
	move_and_slide()
