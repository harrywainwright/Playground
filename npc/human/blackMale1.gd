extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5

@onready var animations = $AnimatedSprite2D

var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = startPosition + Vector2(0, 3*16)

func changeDirection():
	var temp = endPosition
	endPosition = startPosition
	startPosition = temp

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed

func updateAnimation():
	var direction = "Down"
	if velocity.y < 0:
		direction = "Up"

	animations.play("walk" + direction)		



	# func updateAnimation():
	# 	if velocity.length() == 0:
	# 		animations.stop()
	# 		return
	# 	var direction = "Down"
	# 	if velocity.x < 0: direction = "Left"
	# 	elif velocity.x > 0: direction = "Right"
	# 	elif velocity.y < 0: direction = "Up"
	# 	animations.play("walk" + direction)	

func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
