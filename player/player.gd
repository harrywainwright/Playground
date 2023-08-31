extends CharacterBody2D

@export var speed: int = 100
@onready var animations = $AnimationPlayer

var entity_in_range = false
var in_detection_area = false


func player():
	pass

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
		return
	var direction = "Down"
	if velocity.x < 0: direction = "Left"
	elif velocity.x > 0: direction = "Right"
	elif velocity.y < 0: direction = "Up"
	animations.play("walk" + direction)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print(collider.name)

func _on_detection_area_body_entered(body):
	if body.has_method("entity"):
		entity_in_range = true


func _on_detection_area_body_exited(body):	
	if body.has_method("entity"):
		entity_in_range = false


func entityInteraction():
	if entity_in_range == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "start")
			return


func _on_chest_detection_body_entered(body):
	if body.has_method("player"):
		in_detection_area = true

func _on_chest_detection_body_exited(body):	
	if body.has_method("player"):
		in_detection_area = false			


func _physics_process(_delta):
	if in_detection_area == true:
		if Input.is_action_just_pressed("ui_accept"):
			global.found_entity_item = true
			return

	entityInteraction()
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()




	
