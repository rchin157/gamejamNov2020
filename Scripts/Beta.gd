extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var running = false
var attacker
var direction
var numAttackers = 0
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(running)
	if running:
		direction = (get_position() - attacker.get_position()).normalized()
		move_and_slide(direction * 100)


func _on_Area2D_body_entered(body):
	running = true
	attacker = body
	numAttackers += 1


func _on_Area2D_body_exited(body):
	numAttackers -= 1
	if numAttackers == 0:
		running = false
