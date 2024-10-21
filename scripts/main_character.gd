extends CharacterBody2D

class_name MainCharacter

signal directionChanged
signal keyprompt
signal tony_died
signal restart
signal hiding(state)

@onready var hasKeys = false
@onready var inHiding = false

@onready var dead = false

#@onready var flashlightPosition = $flashlight/PositionAnimation
#@onready var flashlightLight = $flashlight/LightAnimation
@onready var keyPrompt = $KeyPrompt
@onready var flashlight = $Camera2D/flashlight
@onready var overlay = $Camera2D/ScreenOverlay
@onready var audioPlayer =$AudioStreamPlayer
@onready var walkingPlayer =$Walking

const SPEED = 70.0
const directions = ["down", "left", "right", "up"]
var direction = directions[0]
var dialogue = preload("res://objects/ui/dialogue_prompt.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handleInput():
	if Input.is_key_pressed(KEY_R):
		emit_signal("restart")
	if dead == false:
		if OS.is_debug_build() and Input.is_key_pressed(KEY_4):
			deathBy("mannequin")
		
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
				$Sprite.play("walk_" + direction)
				if not walkingPlayer.playing:
					var walkingstream: AudioStream = preload("res://assets/sounds/steps.mp3")
					walkingPlayer.set_stream(walkingstream)
					walkingPlayer.play()
			else:
				#states.send_event("idle")
				$Sprite.play("idle_" + direction)
	else:
		$Sprite.play("tony_dead")

func changeDirection(newDirection):
	if direction != newDirection:
		direction = newDirection
		directionChanged.emit(direction)
		match direction:
			"up":
				flashlight.rotation_degrees = 180
				flashlight.position = Vector2(0, -25)
			"down":
				flashlight.rotation_degrees = 0
				flashlight.position = Vector2(0, 25)
			"left":
				flashlight.rotation_degrees = 90
				flashlight.position = Vector2(-25, 0)
			"right":
				flashlight.rotation_degrees = 270
				flashlight.position = Vector2(25, 0)

func _physics_process(_delta):
	handleInput()
	if inHiding == false && dead == false:
		move_and_slide()

func _on_interact_box_area_entered(area: Area2D) -> void:
	if area != null && area.name.contains("Interaction"):
	
		$KeyPrompt.visible = true

func _on_interact_box_area_exited(area: Area2D) -> void:
	if $InteractBox.get_overlapping_areas() == null || $InteractBox.get_overlapping_areas().size() == 0: 
		$KeyPrompt.visible = false
	else:
		#No more interactables?
		for a in $InteractBox.get_overlapping_areas():
			if(a.name.contains("Interaction")):
				return
		$KeyPrompt.visible = false

func contextAction():
	if $InteractBox.get_overlapping_areas() == null : return
	for area in $InteractBox.get_overlapping_areas():
		print_debug(area.name + " " + str(inHiding) + " " + str(area.get_parent()))
		if area.name == "CabineInteractionBox":
			if inHiding == false && area.get_parent().has_method("closeCabine") && area.get_parent().isClosed() != 1:
				area.get_parent().closeCabine()
				inHiding = true
				hiding.emit(true)
				visible = false
				var audiostream: AudioStream = preload("res://assets/sounds/curtain-close.mp3")
				audioPlayer.set_stream(audiostream)
				audioPlayer.play()
				
			elif inHiding == true && area.get_parent().has_method("leaveCabine"):
				inHiding = false
				visible = true
				hiding.emit(false)
				area.get_parent().leaveCabine()
				var audiostream: AudioStream = preload("res://assets/sounds/curtain-open.mp3")
				audioPlayer.set_stream(audiostream)
				audioPlayer.play()
			else:
				dialog(["Seems to be occupied."])
			return
		elif area.name == "KeyInteractionBox":
			overlay.addToContainer("key")
			overlay.changeObjective("Objective:\nGet to the exit!")
			dialog(area.get_parent().interact())
			hasKeys = true
			$KeyPrompt.visible = false
		elif area.name == "BagInteractionBox":
			dialog(area.get_parent().interact())
			$KeyPrompt.visible = false
		elif area.get_parent().has_method("interact") :
			print_debug("Nothing else to say?")
			dialog(area.get_parent().interact())
		elif area.has_method("interact"):
			#For Interactable areas f.e. front door
			dialog(area.interact())

func deathBy(enemy):
	print_debug(enemy + " killed player")
	dead = true
	emit_signal("tony_died")
	match enemy:
		"mannequin":
			print_debug("Tony became part of the clothing store")
			#Sound Effect by Ribhav Agrawal from Pixabay
			var audiostream: AudioStream = preload("res://assets/sounds/death.mp3")
			audioPlayer.set_stream(audiostream)
			audioPlayer.play()


# This will want a Array of Strings
# @tutorial: String[]
func dialog(messages):
	if messages != null:
		var d = dialogue.instantiate()
		d.messages = messages
		add_child(d)


func _on_hiding(state: Variant) -> void:
	get_tree().call_group("enemy", "char_is_hiding",state)
