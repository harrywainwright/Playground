extends CharacterBody2D

@export var speed = 10
@export var limit = 0.5

@onready var animations = $AnimatedSprite2D

var startPosition
var endPosition
var rng = RandomNumberGenerator.new()
var randDir
var randTime

enum npcState{
	Idle = 0,
	Up = 1,
	Down = 2,
	Right = 3,
	Left = 4
}

func _ready():
	rng.randomize()
	startPosition = position
	endPosition = position

func changeDirection():
	var direction
	randDir = rng.randi_range(0, 4)

	match randDir:
		0:	
			endPosition += Vector2(0,0)
			direction = "Idle"
		1: 	
			endPosition +=  Vector2(0,-3*6)
			direction = "Up"
		2: 	
			endPosition += Vector2(0,3*6)
			direction = "Down"
		3: 	
			endPosition += Vector2(3*6,0)
			direction = "Right"
		4: 	
			endPosition += Vector2(-3*6,0)
			direction = "Left"
	
	animations.play("walk" + direction)		
	
	randTime = rng.randf_range(2.0, 5.0)
	print("randTime: " + str(randTime))
	await get_tree().create_timer(randTime).timeout	
	

func updateVelocity():
	var moveDirection = (endPosition - position)

	if moveDirection.length() < limit:
		changeDirection()	

	velocity = moveDirection.normalized() * speed


func _physics_process(_delta):
	updateVelocity()
	move_and_slide()

