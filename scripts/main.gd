extends Node

var hits = []
var greenys = []
var enemys = []
var pause = false
var greeny_timer

@export var greeny_max = 1000
@export var DONUT_TIMER = 3.5

@onready var world_cam: Camera3D = $world_cam
@onready var fps_cam: Camera3D
var player_instance: CharacterBody3D

var world_center = Vector3(0,1,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	self.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	_spawn_player()
	
	create_greeny_spawner(Vector3(-3,8,-12))
	create_greeny_spawner(Vector3(-3,8,-13))
	create_greeny_spawner(Vector3(-3,8,-14))
	create_greeny_spawner(Vector3(-3,8,-15))
	
	self.get_tree().create_timer(60.0).timeout.connect(func():
		var controlls_panel = $hud/Panel
		controlls_panel.visible = false
		#controlls_panel.
		)
	
	
	pass # Replace with function body.

func _spawn_player():
	var player_scene = preload("res://scenes/Player.tscn")
	self.player_instance = player_scene.instantiate()
	self.player_instance.position = self.world_center
	self.player_instance.connect("hit", _on_player_hit)
	self.player_instance.connect("player_col", _on_player_col)
	
	self.fps_cam = player_instance.fps_cam
	self.add_child(player_instance)

func _on_player_col(args):
	var collision_box = ThreeDraw.new().draw_box(args.col_position, Color.YELLOW)
	var collision_vec = ThreeDraw.new().draw_line(args.col_position, args.force_vector, Color.YELLOW)
	
	self.add_child(collision_box)
	self.add_child(collision_vec)	
	self.get_tree().create_timer(0.3).timeout.connect(func():
		collision_box.queue_free()
		collision_vec.queue_free()		
		)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.pause and self.is_processing():
		self.get_tree().paused = true
	else:
		self.get_tree().paused = false

func create_greeny_spawner(pos: Vector3 = Vector3(-5, 10, -13)):
	var greeny_timer = create_timer(DONUT_TIMER)
	#print(self.get_tree_string_pretty())
	self.add_child(greeny_timer)
	greeny_timer.start()
	#self.greeny_timerone
	
	greeny_timer.connect("timeout", func():
		if Global.debug_data.greeny_count >= greeny_max:
			#print("greeny_max reached 8-)")
			return
		else: 
			var greeny = spawn_greeny(pos)
			greenys.append(greeny)
			self.add_child(greeny)
			Global.debug_data.greeny_count += 1
	)

func create_timer(time: float, one_shot: bool = false):
	var timer = Timer.new()
	timer.one_shot = one_shot
	timer.wait_time = time
	return timer
	#self.add_child(self.greeny_timer)
	#self.greeny_timer.start()
	#self.greeny_timerone
	
	#greeny_timer.connect("timeout", func():
		#var greeny = spawn_greeny()
		#self.add_child(greeny)
	#)

func spawn_enemy() -> Node3D:
	const pos0 = Vector3(-15, 3, -7)
	const pos1 = Vector3(-15, 3, -5)
	const pos2 = Vector3(-15, 3, -9)
	
	
	
	const spawn_positions = [pos0, pos1, pos2]		

	var enemy_scene = preload("res://scenes/enemy.tscn")
	var enemy_inst: Node3D = enemy_scene.instantiate()
	enemy_inst.position = spawn_positions[randi() % spawn_positions.size()]
	enemy_inst.connect("died", _on_enemy_died)
	self.add_child(enemy_inst)
	return enemy_inst

func spawn_greeny(pos: Vector3 = Vector3(-5, 10, -13)):
	var greeny = preload("res://scenes/green_donut.tscn")
	var greeny_inst: Node3D = greeny.instantiate()
	greeny_inst.position = pos
	#greeny_inst.connect("died", _on_enemy_died)
	#self.add_child(greeny_inst)
	return greeny_inst
	pass

func _input(event):
	if event.is_action_pressed("clear"):
		while hits.size() > 0:
			var element = hits.pop_front()
			element.queue_free()

	if event.is_action_pressed("action_button"):
		print("Info: action_button pressed")
		#spawn_greeny()
		if enemys.size() <= 0:
			var enemy = spawn_enemy()
			enemys.append(enemy)
		else:
			pass
		pass
	
	if event.is_action_pressed("view"):
		if self.get_viewport().get_camera_3d() == self.player_instance.fps_cam:
			self.world_cam.make_current()
		elif self.get_viewport().get_camera_3d() == self.player_instance.trd_person_cam:
			self.player_instance.fps_cam.make_current()
		else:
			self.player_instance.trd_person_cam.make_current()
	#if event.is_action_pressed("pause"):
		#self.pause = !self.pause

func _on_player_hit(args):
	if args:
		var origin_pos = args.position
		var hit_pos = args.result.position
		var origin = ThreeDraw.new().draw_box(origin_pos, Color.BLUE)
		var hit = ThreeDraw.new().draw_box(hit_pos, Color.RED)
		
		#hits.append_array([hit])
		#var line = _create_line(origin_pos, hit_pos)
		
		var line = ThreeDraw.new().draw_line(origin_pos, hit_pos)
		
		Global.debug_data.last_hit = args.result.collider
		
		self.get_tree().create_timer(1).timeout.connect(func ():
			line.queue_free()
			origin.queue_free()
			hit.queue_free()
			)
			
		#print(args.result.collider)
		#print(args.result)
		#print(args.result.rid)
		var collider: Node3D= args.result.collider
		if collider is enemy_pink_pill:
			collider.take_hit(45.0)
		elif collider is RigidBody3D and collider.has_method("apply_impulse"):
			var cam_x = Global.debug_data.cam_dir.x
			var player_y = Global.debug_data.player_rotation.y
			var player_z = Global.debug_data.player_rotation.y
			
			var impulse_dir = (hit_pos - origin_pos).normalized()
			var impulse_strength = 4.2
			
			var impulse = impulse_dir * impulse_strength
			
			#r.apply_impulse(impulse: Vector3, position: Vector3)
			print(args.result)

			collider.apply_impulse(impulse, args.result.normal)
			#r.apply
			# todo: 
		else:
			print("hit was not a enemy")
			#var r: Node3D = args.result.collider
			print(collider.get_class())
			print(collider.has_method("apply_impulse"))			
		
		self.add_child(line)
		self.add_child(origin)
		self.add_child(hit)		
	pass # Replace with function body.

func _on_enemy_died(args):
	print(args.enemy == enemys[0])
	self.enemys = self.enemys.filter(func (enemy):
		return enemy != args.enemy
	)
	#print(args)
	print(enemys.size())
	#print("YES EYES YES YES")
	pass
