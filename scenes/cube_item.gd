extends Node3D

@onready var rbody = $RigidBody3D

@export var item_mass: float = 1.0
@export var item_color = Color.BLUE_VIOLET
# Called when the node enters the scene tree for the first time.

func _ready():
	rbody.mass = item_mass
	var mesh = self.rbody.get_node_or_null("MeshInstance3D")
	if mesh:
		mesh.mesh.material.albedo_color = item_color
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
