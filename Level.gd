extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tiles = []
var currentScroll = 0

var levelHeight = 12
var levelWidth = 24
var cellwidth = 64
var scrollPeriod = 1
var cellsPassed = levelWidth

var noise = OpenSimplexNoise.new()

onready var tilemap = get_node("TileMap")
onready var camera = get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	initNoise()
	generateInitialTiles()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var step = delta / scrollPeriod * cellwidth
	currentScroll += step
	if currentScroll >= cellwidth:
		newColumn()
		currentScroll = 0
	camera.offset = Vector2(currentScroll, 0)
	

func generateInitialTiles():
	for i in range(levelWidth):
		tiles.append([])
		tiles[i] = []
		for j in range(levelHeight):
			tiles[i].append([])
			var tileval = int(floor((noise.get_noise_2d(i * 2, j / 2) + 1.0) / 2.0 * 3.0))
			tiles[i][j] = tileval
			tilemap.set_cell(i, j, tileval)

func newColumn():
	for i in range(levelWidth - 1):
		for j in range(levelHeight):
			tiles[i][j] = tiles[i + 1][j]
			tilemap.set_cell(i, j, tiles[i][j])
	for j in range(levelHeight):
		var tileval = int(floor((noise.get_noise_2d(cellsPassed * 2, j / 2) + 1.0) / 2.0 * 3.0))
		tiles[levelWidth - 1][j] = tileval
		tilemap.set_cell(levelWidth - 1, j, tileval)
		# print(tileval)
	cellsPassed += 1

func initNoise():
	noise.seed = randi()
	noise.lacunarity = 3.0
	noise.octaves = 2
	noise.period = 20.0
	noise.persistence = 0.8
