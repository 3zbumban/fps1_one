class_name ThreeDraw

extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func draw_box(pos: Vector3, color: Color=Color.BLUE, cast_shadow: bool = false) -> MeshInstance3D:
	var red_box = MeshInstance3D.new()
	var mesh = BoxMesh.new()
	var red_mat = StandardMaterial3D.new()
	red_mat.albedo_color = color
	mesh.size = Vector3(0.2, 0.2, 0.2)
	mesh.material = red_mat
	red_box.mesh = mesh
	red_box.cast_shadow = cast_shadow
	red_box.position = pos
	return red_box

func draw_line(pos1: Vector3, pos2: Vector3, color: Color = Color.ALICE_BLUE, cast_shadow: bool = false) -> MeshInstance3D:
	var line_mesh = MeshInstance3D.new()
	var imm_mash = ImmediateMesh.new()
	var line_mat = StandardMaterial3D.new()
	#var line_mat = ORMMaterial3D.new()
	
	imm_mash.surface_begin(Mesh.PRIMITIVE_LINES, line_mat)
	imm_mash.surface_add_vertex(pos1)
	imm_mash.surface_add_vertex(pos2)		
	imm_mash.surface_end()
	
	line_mesh.mesh = imm_mash
	line_mesh.cast_shadow = cast_shadow
	
	line_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	line_mat.albedo_color = color
	
	return line_mesh
