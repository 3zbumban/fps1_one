extends Node

const GLOBAL_VER = 1.337
var debug_data = {
	"ver": GLOBAL_VER
}

func set_player_dir(dir: Vector3):
	self.player_data.dir = dir

func _process(delta):
	self.debug_data["fps"] = Engine.get_frames_per_second()
