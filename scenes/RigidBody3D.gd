extends RigidBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.position.y -= gravity * delta
	#apply_force(Vector3(0,-1,0))
	pass
