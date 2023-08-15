extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5

@onready var animations = $AnimatedSprite2D

var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = startPosition + Vector2(3*16, 3*16)

func changeDirection():
	var temp = endPosition
	endPosition = startPosition
	startPosition = temp
	

func updateVelocity():
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed

func updateAnimation():
	var direction = "Idle"
	if velocity.y < 0: direction = "Up"
	if velocity.y > 0: direction = "Down"
	if velocity.x < 0: direction = "Right"
	if velocity.x > 0: direction = "Left"

	animations.play("walk" + direction)		

func _physics_process(_delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()