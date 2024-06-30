extends Control

var screen_center: Vector2
@export var point_size: float = 3.0
@export var color: Color = Color.GREEN

# Called when the node enters the scene tree for the first time.
func _ready():
	#queue_redraw()
	pass # Replace with function body.

func _draw():
	draw_circle(screen_center, point_size, color)
	pass
	#var screen_center = get_viewport().size / 2
	#$hud.draw_line(Vector2(0,0), get_viewport().size)
