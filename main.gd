extends Node

var hits = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _create_box(pos: Vector3, color: Color=Color.BLUE) -> MeshInstance3D:
	var red_box = MeshInstance3D.new()
	var mesh = BoxMesh.new()
	var red_mat = StandardMaterial3D.new()
	red_mat.albedo_color = color
	mesh.size = Vector3(0.2, 0.2, 0.2)
	mesh.material = red_mat
	red_box.mesh = mesh
	red_box.position = pos
	return red_box

func _input(event):
	if event.is_action_pressed("clear"):
		while hits.size() > 0:
			var element = hits.pop_front()
			element.queue_free()

func _on_player_hit(args):
	if args:
		var origin = _create_box(args.position, Color.BLUE)
		var hit = _create_box(args.result.position, Color.RED)
		
		hits.append_array([origin, hit])
				
		self.add_child(origin)
		self.add_child(hit)		
	pass # Replace with function body.
