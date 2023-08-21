extends CharacterBody2D

@export var speed = 10
@export var limit = 0.5

@onready var animations = $AnimatedSprite2D

var startPosition = global_position
var endPosition
var rng = RandomNumberGenerator.new()
var randDir
var direction

enum npcState{
	Idle = 0,
	Up = 1,
	Down = 2,
	Right = 3,
	Left = 4
}

func _ready():
	rng.randomize()
	endPosition = position
	changeDirection()

func changeDirection():
	randDir = rng.randi_range(1, 4) #removed idle for now (only triggres for instance, then changes)

	match randDir:
		0:	
			endPosition += Vector2(0,0)
			direction = "Idle"
		1: 	
			endPosition +=  Vector2(0,-3*8)
			direction = "Up"
		2: 	
			endPosition += Vector2(0,3*8)
			direction = "Down"
		3: 	
			endPosition += Vector2(3*8,0)
			direction = "Right"
		4: 	
			endPosition += Vector2(-3*8,0)
			direction = "Left"
	
	animations.play("walk" + direction)		

	# wait_for_timer()

	# randTime = rng.randf_range(2.0, 5.0)
	# await get_tree().create_timer(randTime).timeout	
	
	
func returnToStart(direction):
	if direction == "Up":
		endPosition += Vector2(0,3*8)
		direction = "Down"
	elif direction == "Down":
		endPosition +=  Vector2(0,-3*8)
		direction = "Up"
	elif direction == "Right":
		endPosition += Vector2(-3*8,0)
		direction = "Left"
	elif direction == "Left":
		endPosition += Vector2(3*8,0)
		direction = "Right"

	animations.play("walk" + direction)		

	#wait_for_timer()

	# randTime = rng.randf_range(2.0, 5.0)
	# await get_tree().create_timer(randTime).timeout	


func updateVelocity():
	var moveDirection = (endPosition - position)
	velocity = moveDirection.normalized() * speed

	if moveDirection.length() <= limit && direction != null:
		returnToStart(direction)
		
		direction = null

	elif moveDirection.length() <= limit && direction == null:
		changeDirection()
		

func _physics_process(_delta):
	updateVelocity()
	move_and_slide()

