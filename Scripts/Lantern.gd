extends "res://Scripts/LevelEntity.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maxFuel = 20.0
var fuel = maxFuel
var state = 3
var animator

# Called when the node enters the scene tree for the first time.
func _ready():
	animator = get_node("AnimatedSprite")
	animator.set_animation("high")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fuel > 0:
		fuel -= delta
	else:
		fuel = 0
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
