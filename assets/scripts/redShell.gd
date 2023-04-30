extends KinematicBody2D

onready var myScene = load("res://scenes/redShellEnemy.tscn")

var damage = 1
var stuckFrames = 0

var ImDeadEcksDee = false

onready var LFloor = $LFloor
onready var RFloor = $RFloor
onready var LWall = $LWall
onready var RWall = $RWall

onready var rng = RandomNumberGenerator.new()

var velocity = Vector2(0, 0)
var gravity = Vector2(0, 50)
var direction = 1
var speed = 5000

func canGo():
	return (
		(direction == 1 and RFloor.is_colliding() and not RWall.is_colliding()) or 
		(direction == -1 and LFloor.is_colliding() and not LWall.is_colliding())
	)

func die():
	ImDeadEcksDee = true
	velocity = Vector2(0, 0)
	rotation_degrees += 5
	$CollisionShape2D.position = Vector2(0, -99999)
	stuckFrames = 0

func _physics_process(delta):
	if ImDeadEcksDee:
		velocity += gravity
		position += velocity
		stuckFrames += 1
		
		if stuckFrames > 50:
			var newMe = myScene.instance()
			get_parent().add_child(newMe)
			queue_free()
	else:
		var speedThisFrame = Vector2(0, 0)
		if canGo():
			speedThisFrame = move_and_slide(Vector2(speed*direction*delta, 0))
		else:
			#print("can't go")
			direction *= -1
		
		stuckFrames -= 1
		if abs(speedThisFrame.x) < 20:
			stuckFrames = stuckFrames if stuckFrames > 0 else 0
			stuckFrames += 2
		
			if stuckFrames > 100:
				die()
