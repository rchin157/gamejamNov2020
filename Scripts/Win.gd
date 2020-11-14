extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animator = get_node("AnimatedSprite")
onready var txt = get_node("RichTextLabel")
onready var btn = get_node("Button")
onready var particle = get_node("KINO")
var currentFrame = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	if MultiplayerManager.truegame:
		MultiplayerManager.game_ended(true)
	animator.frame = 0
	Music.stopAll()
	Music.playSFX(7)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animator.frame != currentFrame:
		currentFrame = animator.frame
		changeFrame(currentFrame)
	pass

func changeFrame(frame: int):
	particle.show()
	particle.set_amount(frame*10)
	if frame == 11:
		particle.hide()
		txt.show()
		btn.show()

func _on_Button_pressed():
	Music.stopSFX(7)
	get_tree().change_scene("res://Level/Main Menu.tscn")
	pass # Replace with function body.
