class_name enemy_pink_pill

extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var hp = 100;
@onready var label = $Label3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

signal gotHit
signal died

func take_hit(hit: float):
	self.hp -= hit
	if hp <= 0:
		print("enemy died %s" % [self])
		
		if not audio_player.playing:
			audio_player.play(24.54)
		
		self.get_tree().create_timer(1.2).timeout.connect(func ():
			if audio_player.playing:
				audio_player.stop()
				self.emit_signal("died", {"enemy": self})
				self.queue_free()
		)
		#self.queue_free()

func _physics_process(delta):
	var player_basis = Global.debug_data.player_basis
	var player_dir = Global.debug_data.player_basis
	var player_rotation = Global.debug_data.player_rotation
	
	label.text = "%s/100" % self.hp
	# todo: rotate label
	label.rotation.y = player_rotation.y + deg_to_rad(180)
	pass
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	##var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	##var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
