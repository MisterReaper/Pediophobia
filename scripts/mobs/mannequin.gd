extends CharacterBody2D


signal kills
var target

@onready var states: StateChart = $States
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audioPlayer = $AudioStreamPlayer2D
@onready var detectionRotator = $detectionRotator
@onready var huntingRay = $RayCastForHunting
const SPEED = 40.0
const directions = ["down", "left", "right", "up"]
var direction = directions[0]
var debugnode

func _ready():
	add_to_group("enemy")
	if false && OS.is_debug_build():
		debugnode = $debugInfoTemplate
		debugnode.visible = true
		self.remove_child(debugnode)
		self.get_parent().call_deferred("add_child", debugnode)

func _physics_process(delta):
	if target:
		var target_pos = target.global_position
		huntingRay.target_position = target_pos
		print_debug(str(huntingRay.get_collider()) + str(target.global_position))
		if huntingRay.get_collider() != null:
			velocity = global_position.direction_to(target_pos) * SPEED
			if velocity.y:
				direction = "down" if velocity.y > 0.0 else "up"
				detectionRotator.rotation_degrees = 0 if velocity.y > 0.0 else 180
			else:
				direction = "left" if velocity.x < 0.0 else "right"
				detectionRotator.rotation_degrees = 90 if velocity.y > 0.0 else 270
				
			states.send_event("run")
			playAnimation("run_" + direction)
			move_and_slide()
			if randi_range(0,3000) == 3000:
				#audioPlayer.stream = load("res://assets/sounds/chaserGhost_idle.mp3")
				#audioPlayer.play()
				pass
			if debugnode:
				debugnode.position = target_pos
		else:
			target = null
	else:
		#states.send_event("idle")
		pass
	
func playAnimation(anim):
	if sprite.animation != anim:
		var frame = sprite.frame
		sprite.play(anim)
		sprite.frame = frame

func resetAnimation():
	sprite.frame = 0

func _on_idle_state_entered():
	resetAnimation()
	playAnimation("idle_" + direction)

func _on_hit_box_area_entered(body):
	print_debug("Body entered: "+ body.name)
	if body.name == "WholeBodyBox":
		kills.emit("chaserGhost")


func _on_detection_area_area_entered(area: Area2D) -> void:
	print_debug("Body entered: "+ area.name)
	if area.name == "InteractBox":
		target = area
		#audioPlayer.stream = load("res://assets/sounds/chaserGhost_take_chase.mp3")
		#audioPlayer.play()
		print_debug("Target spotted")
