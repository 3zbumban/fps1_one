extends PanelContainer

var version_label = Label.new()
var player_dir_label = Label.new()

var debug_map = {}

var debug_data = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	self.debug_data = Global.debug_data
	#_set_labels()

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

func _build_console():
	self.debug_data = Global.debug_data
	if self.debug_data.size() > 0:
		#for child in $MarginContainer/VBoxContainer.get_children():
			#child.queue_free()	
		for key in self.debug_data:
			var val = debug_data[key]
			var text = "%s = %s" % [key, val]
			#var text = text.
			
			if debug_map.has(key):
				# upddate
				debug_map[key].label_node.text = text
				debug_map[key].value = val 
			else:
				var label_node = Label.new()
				label_node.autowrap_mode = TextServer.AUTOWRAP_WORD
				label_node.text = text
				debug_map[key] = {
					"label_node": label_node,
					"value": val
				}
				$MarginContainer/VBoxContainer.add_child(label_node)
		#print(debug_data)
	else:
		print("Info: no items in debug map yet")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible:
		#_update_labels()
		_build_console()
	
	if Input.is_action_just_pressed("console"):
		self.visible = !self.visible
		pass
