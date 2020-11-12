extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var running = false
var attacker
var direction
var passiveDirection
var numAttackers = 0
var speed = 100
var animator
var facingRight = true
var walkTimer = 4
var walking = false

var influences = []

# Called when the node enters the scene tree for the first time.
func _ready():
	animator = get_node("AnimatedSprite")
	passiveDirection = Vector2.LEFT
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(running)
	if numAttackers == 0:
		influences.clear()
	if running:
		walkTimer = 8
		walking = false
		direction = Vector2.ZERO
		for body in influences:
			direction += get_position() - body.get_position()
		direction = direction.normalized() * speed
		if facingRight and direction.x < 0:
			animator.set_animation("chaseLeft")
			facingRight = false
		elif not facingRight and direction.x >= 0:
			animator.set_animation("chaseRight")
			facingRight = true
		move_and_slide(direction)
	walkTimer -= delta
	if walkTimer <= 0:
		togglewalk()
	if walking:
		move_and_slide(passiveDirection * (speed / 3))


func _on_Area2D_body_entered(body):
	running = true
	influences.append(body)
	if body.get_position().x > get_position().x:
		facingRight = false
		animator.set_animation("chaseLeft")
	else:
		animator.set_animation("chaseRight")
		facingRight = true
	attacker = body
	numAttackers += 1
	


func _on_Area2D_body_exited(body):
	influences.erase(body)
	numAttackers -= 1
	if numAttackers <= 0:
		numAttackers = 0
		influences.clear()
		running = false
		if facingRight:
			animator.set_animation("idleRight")
		else:
			animator.set_animation("idleLeft")

func togglewalk():
	if walking:
		if facingRight:
			animator.set_animation("idleRight")
		else:
			animator.set_animation("idleLeft")
		walking = false
		walkTimer = 5
		if passiveDirection == Vector2.RIGHT:
			passiveDirection = Vector2.DOWN;
		elif passiveDirection == Vector2.DOWN:
			passiveDirection = Vector2.LEFT
		elif passiveDirection == Vector2.LEFT:
			passiveDirection = Vector2.UP
		elif passiveDirection == Vector2.UP:
			passiveDirection = Vector2.RIGHT
	else:
		if passiveDirection == Vector2.RIGHT:
			facingRight = true
			animator.set_animation("walkRight")
		elif passiveDirection == Vector2.LEFT:
			facingRight = false
			animator.set_animation("walkLeft")
		else:
			animator.set_animation("walkRight")
		walking = true
		walkTimer = 2

func action_tick(tooltime):
	Music.toggleSong(6,true)
	return .action_tick(tooltime)

func action_finish(rem: bool):
	print('generic task complete notification')
#	var drop = MultiplayerManager.itemSpawner.instance();
#	drop.set_position(get_position())
#	get_parent().add_child(drop)
	Music.toggleSong(6,false)
	_dispose()
	return

func actionStopped():
	Music.toggleSong(6,false)
