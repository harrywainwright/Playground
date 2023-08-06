extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5

@onready var animations = $AnimatedSprite2D

var startPosition
var endPosition
#var rng = RandomNumberGenerator.new()

func _ready():
	startPosition = position
	endPosition = startPosition + Vector2(0, 3*16)

func changeDirection():
	var temp = endPosition
	endPosition = startPosition
	startPosition = temp

# func wait():
# 	var rng = RandomNumberGenerator.new()
# 	#randomize end poisition timer
# 	var rand = rng.randf_range(100, 300)
# 	#pause npc until changing direction
# 	await $Timer.rand

	

func updateVelocity():
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed

func updateAnimation():
	# if velocity.length() == 0:
	#  	animations.stop()
	#  	return
	var direction = "Down"
	if velocity.y < 0: direction = "Up"
	animations.play("walk" + direction)		

func _physics_process(_delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
