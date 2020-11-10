extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tiles = []
var currentScroll = 0

var levelHeight = 12
var levelWidth = 24

onready var tilemap = get_node("TileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	generateInitialTiles()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentScroll += 1
	if currentScroll == 120:
		newColumn()
		currentScroll = 0

func generateInitialTiles():
	for i in range(levelWidth):
		tiles.append([])
		tiles[i] = []
		for j in range(levelHeight):
			tiles[i].append([])
			tiles[i][j] = 0
			tilemap.set_cell(i, j, 0)

func newColumn():
	for i in range(levelWidth):
		for j in range(levelHeight - 1):
			tiles[i][j] = tiles[i][j + 1]
	for j in range(levelHeight):
		tiles[levelWidth - 1][j] = 1
