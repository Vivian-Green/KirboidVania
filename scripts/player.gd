extends KinematicBody2D

const UP = Vector2(0, -1)
const white = Color(1, 1, 1, 1)
const red = Color(1, 0.3, 0.3, 1)

#player movement consts
const GRAVITY = 2000.0
const WALK_SPEED = 80
const JUMP_SPEED = -550
const HOVER_SPEED = -70
const HOVER_MAX_SPEED = -50
const COYOTE_TIME = 0.1#you have 6 frames of coyote time, don't blame the game for eating your input, you misinputted.
const GROUND_FRICTION = 0.75
const AIR_FRICTION = 0.75
const KNOCKBACK = Vector2(1200, 750)
const STEP_HEIGHT = -16

#juice
var landingSquash = 0.8 #percent
var landingSquashFallThreshold = 0.25 #seconds
var landingSquashFramesMax = 4 #frames
var landingSquashFrames = landingSquashFramesMax

var jumpingStretch = 1.1 #percent

var stretchBack = 0.25 #percent

#node references
onready var saveHandler = get_parent()
onready var LEFT = $left
onready var RIGHT = $right
onready var DOWN = $down
onready var DLEFT = $downLeft
onready var DRIGHT = $downRight
onready var ULEFT = $upLeft
onready var URIGHT = $upRight

onready var playerBody = $body

onready var baseScale = scale

#other vars
var velocity = Vector2()
var floatTime = 0

var spawnPosition = Vector2(-2635, -1597)
var health = 3
var maxHealth = 3
var invulnFrames = 0
var maxInvulnFrames = 10

var canJump = false
var canFludd = true
var fluddJuice = 100
var maxFluddJuice = 100
var isOnGround = false
var savedRecently = false


#Dict of inventory items & where they are in the file structure
onready var inventoryPreloadsDict = {
	"shoes": preload("res://scenes/inventory/shoes.tscn")
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~inventory stuff~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func addItemToInventory(item):
	$Inventory.add_child(item.instance())
	
func _on_pickupRange_area_entered(area):
	#pickup nearby items
	if inventoryPreloadsDict.has(area.name):
		#if it exists, proceed
		var item = inventoryPreloadsDict[area.name]
		DataHandler.inventory[area.name] = true
		addItemToInventory(item)
	
	area.get_parent().queue_free()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~player controller stuff~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func handleNoLongerFloating():
	#squash & stretch
	if floatTime > landingSquashFallThreshold:
		landingSquashFrames = landingSquashFramesMax
	if landingSquashFrames > 0:
		playerBody.scale.y *= landingSquash
		landingSquashFrames -= 1
	
	#other landing tasks
	fluddJuice = maxFluddJuice
	floatTime = 0

func handleFloating(delta):
	#sets isOnGround and float time, and handles gravity
	isOnGround = LEFT.is_colliding() or RIGHT.is_colliding() or DOWN.is_colliding()
	
	if isOnGround:
		handleNoLongerFloating()
	else:
		if floatTime < COYOTE_TIME/3:#1/3 of coyote time is spent literally floating, lol.
			#allow jump, not fall
			velocity.y = clamp(velocity.y, -9999, 0)
		else:
			velocity.y += delta * GRAVITY
		floatTime += delta

func stepUp(direction):
	#onto the finger, player, c'mon
	#checks raycasts in the current direction, and floatTime, to see if the player has room to / should step up this frame
	var canStepUp = (
		floatTime < COYOTE_TIME and
		(direction == -1 and DLEFT.is_colliding() and not ULEFT.is_colliding()) or 
		(direction == 1 and DRIGHT.is_colliding() and not URIGHT.is_colliding())
	)
	
	if canStepUp:
		velocity.y = 0
		position += Vector2(0, STEP_HEIGHT)

func walk(L, R):
	#handles walking in either direction, with booleans for L and R input
	var directionToWalk = float(L)-0.5
	directionToWalk = -1*(directionToWalk/abs(directionToWalk))
	var directionToWalk2 = float(R)-0.5
	directionToWalk2 = directionToWalk2/abs(directionToWalk2)
	
	directionToWalk += directionToWalk2

	if abs(directionToWalk) < 1:
		return
	directionToWalk = directionToWalk/abs(directionToWalk)#set to -1 for L, 1 for R, without ifs
	
	#print(directionToWalk)
	if velocity.x*directionToWalk < 0:
		scale.x *= 0.6
	playerBody.scale.x = directionToWalk
	velocity.x +=WALK_SPEED*directionToWalk
	stepUp(directionToWalk)
	
func hover():
	if canFludd and fluddJuice > 2:
		fluddJuice -= 3
		
		if velocity.y > HOVER_MAX_SPEED:
			velocity.y += HOVER_SPEED
			
		fluddJuice = fluddJuice if fluddJuice <= maxFluddJuice else maxFluddJuice
		return true
	return false

func duckOrDive(delta, down):
	if not down: 
		return
	
	if floatTime < 0.25:
		scale.y = 0.5
	else:
		scale.y *= 1.1
		scale.x *= 0.9
		velocity.y += GRAVITY*0.5*delta
		
func jumpAndHover(_delta, up):
	#handles jumping, diving, ducking, and fludd
	var shouldJetpackBeOn = false
	
	if up and floatTime < COYOTE_TIME and canJump:
		#if can jump, do
		velocity.y = JUMP_SPEED
		playerBody.scale.y *= jumpingStretch
	elif up and canJump and floatTime > 0.3:
		shouldJetpackBeOn = hover()
	
	playerBody.get_node("jetpack").get_node("jetpack-on").visible = shouldJetpackBeOn
	fluddJuice += 1

func handleInputs(delta):		
	#what it says on the tin
	walk(Input.is_action_pressed("ui_left"), Input.is_action_pressed("ui_right"))
	
	jumpAndHover(delta, Input.is_action_pressed("ui_up"))
	duckOrDive(delta, Input.is_action_pressed("ui_down"))


func applyVelocity(prevVel):
	#what it says on the tin
	velocity = move_and_slide(velocity, UP)
	
	if velocity.y < prevVel.y:
		#if y velocity lowered in move_and_slide, we hit floor
		handleNoLongerFloating()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~damage~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func respawn():
	position = spawnPosition
	health = maxHealth
	playerBody.get_node("jetpack").get_node("jetpack-on").visible = false

func onHurtboxCollision(hurtbox):
	#print("oof ouch my bones owie")	
	if invulnFrames < 1:
		invulnFrames = maxInvulnFrames
		health -= hurtbox.damage
		var direction = position.x - hurtbox.position.x
		direction = direction/abs(direction)
		velocity += Vector2(direction, -1).normalized()*KNOCKBACK
		
		playerBody.scale *= Vector2(0.75, 0.75)
		if health < 1:
			respawn()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

func _physics_process(delta):
	scale = lerp(scale, baseScale*(scale.x/abs(scale.x)), stretchBack)
	playerBody.scale.y = lerp(playerBody.scale.y, 1, stretchBack)
	
	if invulnFrames > 0:
		invulnFrames -= 1
	
	set_modulate(white.linear_interpolate(red, invulnFrames/5))
	
	handleFloating(delta) #sets isOnGround and float time, and handles gravity
	handleInputs(delta)
	applyVelocity(velocity)
	
	if isOnGround:
		velocity.x *= GROUND_FRICTION
	else:
		velocity.x *= AIR_FRICTION
	
	#every 10 seconds, save, lol
	#debug: fix
	if not savedRecently and DataHandler.playTime % 10 == 0:
		savedRecently = true
		saveHandler.saveGame(DataHandler.saveSlot)
	else:
		savedRecently = false

func _ready():
	respawn()
	while not DataHandler.inventory.has("shoes"):
		yield(get_tree().create_timer(0.1), "timeout")
		#wait for DataHandler to set up its inventory
		#todo: add flag in datahandler to check directly
		
	for k in DataHandler.inventory:
		#for everything in datahandler.inventory, if TRUE, load it into the player's inv.
		if DataHandler.inventory[k]:
			addItemToInventory(inventoryPreloadsDict[k])
