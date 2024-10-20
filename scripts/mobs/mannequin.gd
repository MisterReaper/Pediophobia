extends CharacterBody2D


signal kills
var target

@onready var states: StateChart = $States
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audioPlayer = $AudioStreamPlayer2D
@onready var detectionRotator = $detectionRotator
@onready var huntingRay = $RayCastForHunting
@onready var navigation_agent: NavigationAgent2D = $Navigation/NavigationAgent2D
const SPEED = 80.0
const ACCELERATION = 7
const directions = ["down", "left", "right", "up"]
var directionAnimation = directions[0]
var debugnode
@onready var startPosition = self.global_position
var mainCharInHiding
var targetIsChar = false

func _ready():
	add_to_group("enemy")
	mainCharInHiding = false
	if false && OS.is_debug_build():
		debugnode = $debugInfoTemplate
		debugnode.visible = true
		self.remove_child(debugnode)
		self.get_parent().call_deferred("add_child", debugnode)



func _physics_process(delta):
	if target:
		
		var direction = Vector2.ZERO
		
		direction = navigation_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction*SPEED, ACCELERATION * delta)
		
		if velocity.y:
			directionAnimation = "down" if velocity.y > 0.0 else "up"
			detectionRotator.rotation_degrees = 0 if velocity.y > 0.0 else 180
		else:
			directionAnimation = "left" if velocity.x < 0.0 else "right"
			detectionRotator.rotation_degrees = 90 if velocity.y > 0.0 else 270
		playAnimation("run_" + directionAnimation)
		move_and_slide()
		#	if randi_range(0,3000) == 3000:
		#		#audioPlayer.stream = load("res://assets/sounds/chaserGhost_idle.mp3")
		#		#audioPlayer.play()
		#		pass
		#	if debugnode:
		#		debugnode.position = target_pos
		#else:
		#	target = null
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
	playAnimation("idle_" + directionAnimation)

func _on_hit_box_area_entered(body):
	print_debug("Body entered: "+ body.name)
	if body.name == "WholeBodyBox":
		kills.emit("chaserGhost")


func _on_detection_area_area_entered(area: Area2D) -> void:
	print_debug("Body entered: "+ area.name)
	if area.name == "InteractBox" && !mainCharInHiding:
		target = area
		targetIsChar = true

		#audioPlayer.stream = load("res://assets/sounds/chaserGhost_take_chase.mp3")
		#audioPlayer.play()
		print_debug("Target spotted")


func _on_timer_timeout() -> void:
	
	if target && !mainCharInHiding && targetIsChar:
		navigation_agent.target_position = target.global_position
	elif global_position != startPosition:
		targetIsChar = false
		navigation_agent.target_position = startPosition
	else:
		pass


func char_is_hiding(state) -> void:
	mainCharInHiding = state
	print_debug(mainCharInHiding)

func _on_navigation_agent_2d_target_reached() -> void:
	target = null
