extends CharacterBody2D

class_name MainCharacter

signal directionChanged
signal keyprompt

@onready var hasKeys = false
@onready var inHiding = false

@onready var flashlightPosition = $flashlight/PositionAnimation
@onready var flashlightLight = $flashlight/LightAnimation
@onready var keyPrompt = $KeyPrompt

const SPEED = 70.0
const directions = ["down", "left", "right", "up"]
var direction = directions[0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handleInput():
	
	if OS.is_debug_build() and Input.is_key_pressed(KEY_4):
		deathBy("kill_switch")
	
	if Input.is_action_just_pressed("interact"):
		contextAction()
	
	if inHiding == false:
		var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up","ui_down")
		velocity = moveDirection * SPEED
		if moveDirection.length():
			if moveDirection.y:
				changeDirection("down" if moveDirection.y > 0.0 else "up")
			else:
				changeDirection("left" if moveDirection.x < 0.0 else "right")
			#states.send_event("run")
			#$Sprite.playAnimation("walk_" + direction)
		else:
			#states.send_event("idle")
			pass

func changeDirection(newDirection):
	if direction != newDirection:
		direction = newDirection
		directionChanged.emit(direction)
		#flashlightPosition.play(direction)

func _physics_process(_delta):
	handleInput()
	move_and_slide()

func _on_interact_box_area_entered(area: Area2D) -> void:
	if area != null:
		if $InteractBox.get_overlapping_areas().size() > 0:
			print_debug($InteractBox.get_overlapping_areas().size() )
			$KeyPrompt.visible = true
	pass

func _on_interact_box_area_exited(area: Area2D) -> void:
	print_debug($InteractBox.get_overlapping_areas().size() )
	if $InteractBox.get_overlapping_areas() == null || $InteractBox.get_overlapping_areas().size() == 0: 
		$KeyPrompt.visible = false
		

func contextAction():
	if $InteractBox.get_overlapping_areas() == null : return
	for area in $InteractBox.get_overlapping_areas():
		print_debug(area.name + " " + str(inHiding) + " " + str(area.get_parent()))
		if area.name == "CabineInteractionBox":
			if inHiding == false && area.get_parent().has_method("closeCabine") && area.get_parent().isClosed() != 1:
				area.get_parent().closeCabine()
				inHiding = true
				visible = false
				print_debug("hide")
				return
			if inHiding == true && area.get_parent().has_method("leaveCabine"):
				inHiding = false
				visible = true
				area.get_parent().leaveCabine()
				print_debug("leave")
				return
		return

func deathBy(enemy):
	print_debug(enemy + " killed player")
	
	match enemy:
		"mannequin":
			print_debug("Tony became part of the clothing store")
