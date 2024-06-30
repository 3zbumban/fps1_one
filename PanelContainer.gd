extends PanelContainer

var version_label = Label.new()
var player_dir_label = Label.new()

var debug_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	_set_labels()

func _set_labels():
	_update_labels()
	
	$MarginContainer/VBoxContainer.add_child(version_label)
	$MarginContainer/VBoxContainer.add_child(player_dir_label)
	
func _update_labels():
	version_label.text = "ver: %s" % Global.debug_data.ver
	player_dir_label.text = "data: %s" % Global.debug_data
	
	# part 2
	#for label in Global.debug_data:
		#var val = Global.debug_data[label]
		#var label_node = Label.new()
		#label_node.text = "%s = %s" % [label, val]
		#
		#debug_map[label] = {
			#"label_node": label_node,
			#"value": val
		#}
		#
		#$MarginContainer/VBoxContainer.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible:
		_update_labels()
	
	if Input.is_action_just_pressed("console"):
		self.visible = !self.visible
		pass
