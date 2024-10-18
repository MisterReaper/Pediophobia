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
	
	if Input.is_key_pressed(KEY_F) || Input.is_key_pressed(KEY_SPACE):
		contextAction()
	
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up","ui_down")
	velocity = moveDirection * SPEED
	if moveDirection.length():
		if moveDirection.y:
			changeDirection("down" if moveDirection.y > 0.0 else "up")
		else:
			changeDirection("left" if moveDirection.x < 0.0 else "right")
		#states.send_event("run")
		#playAnimation("run_" + direction)
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
			pass
	pass

func _on_interact_box_area_exited(area: Area2D) -> void:
	if $InteractBox.get_overlapping_areas() == null : 
		keyPrompt.emit

func contextAction():
	if $InteractBox.get_overlapping_areas() == null : return
	for area in $InteractBox.get_overlapping_areas():
		print_debug(area.name)
		if area.name == "BatteryPickUpArea":
			if area.get_parent().has_method("collect"):
				area.get_parent().collect()

func deathBy(enemy):
	print_debug(enemy + " killed player")
	
	match enemy:
		"mannequin":
			print_debug("Tony became part of the clothing store")
