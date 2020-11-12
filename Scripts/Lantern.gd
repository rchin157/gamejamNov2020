extends "res://Scripts/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const FUELPERLOG = 40
var maxRange = 250;
var minRange = 100;
var tint_color;
var shape
var maxFuel = 80
var fuel = maxFuel
var state = 3

func get_pushable():
	return true

func attemptPush(displace: Vector2, blacklist):
	.attemptPush(displace, blacklist)

func _draw():
	draw_circle(Vector2(0,0),shape.get_radius(),tint_color)

# Called when the node enters the scene tree for the first time.
func _ready():
	waterlogger = false;
	animator = get_node("AnimatedSprite")
	animator.set_animation("high")
	shape = get_node("Area2D/CollisionShape2D").get_shape()
	tint_color = Color8(255,153,0)
	tint_color.a = 0.1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fuel > 0:
		Music.toggleSong(8,true)
		fuel -= delta
	else:
		fuel = 0
		Music.toggleSong(8,false)
	#print(fuel)
	updateLantern()

func updateLantern():
	if fuelToState() != state:
		state = fuelToState()
		print("new: " + String(state) + ", fuel: " + String(fuel))
		match state:
			0:
				animator.set_animation("off")
			1:
				animator.set_animation("low")
			2:
				animator.set_animation("med")
			3:
				animator.set_animation("high")
	if(fuel>0):
		shape.set_radius(minRange+fuel/maxFuel*(maxRange-minRange))
	else:
		shape.set_radius(0)
	update()
	
func addFuel(amt):
	if fuel <= 0:
		fuel = 0
	if fuel + amt > maxFuel:
		fuel = maxFuel
	else:
		fuel = fuel + amt
		
func fuelToState():
	if fuel <= 0:
		return 0
	elif fuel <= (1.0 / 3.0) * maxFuel:
		return 1
	elif fuel <= (2.0 / 3.0) * maxFuel:
		return 2
	elif fuel <= maxFuel:
		return 3

#NOTE CHECK IF IT IS WOOD IN FINAL VERSION 
func _on_Refueling_body_entered(body):
	#WHACK
	if(body != self and !body.food):
		body._dispose();
		addFuel(FUELPERLOG)
	pass # Replace with function body.
