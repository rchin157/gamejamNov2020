extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tiles = []
var tileImgs = []
var currentScroll = 0

var levelHeight = 12
var levelWidth = 24
var cellwidth = 64
var scrollPeriod = 1
var cellsPassed = levelWidth

var noise = OpenSimplexNoise.new()

var rng = RandomNumberGenerator.new()

var tree = load("res://Entities/Tree.tscn")

onready var tilemap = get_node("TileMap")
onready var camera = get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.seed = 0
	initNoise()
	generateInitialTiles()
	if(MultiplayerManager.is_server):
		MultiplayerManager.listeningPlayer = get_node("Player2");
	else:
		MultiplayerManager.listeningPlayer = get_node("Player");
	MultiplayerManager.listeningPlayer.local= false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var step = delta / scrollPeriod * cellwidth
	currentScroll += step
	if currentScroll >= cellwidth:
		newColumn()
		snap(currentScroll)
		currentScroll = 0
	camera.offset = Vector2(currentScroll, 0)
	

func generateInitialTiles():
	for i in range(levelWidth):
		tiles.append([])
		tileImgs.append([])
		tiles[i] = []
		tileImgs[i] = []
		for j in range(levelHeight):
			tiles[i].append([])
			tileImgs[i].append([])
			var tileval = tileBias(int(round((noise.get_noise_2d(i * 2, j) + 1.0) * 8.0)))
			tiles[i][j] = tileval
			tileImgs[i][j] = tileImgSelect(tileval)
			tilemap.set_cell(i, j, tileImgs[i][j])

func newColumn():
	for i in range(levelWidth - 1):
		for j in range(levelHeight):
			tiles[i][j] = tiles[i + 1][j]
			tileImgs[i][j] = tileImgs[i + 1][j]
			tilemap.set_cell(i, j, tileImgs[i][j])
	for j in range(levelHeight):
		var tileval = tileBias(int(round((noise.get_noise_2d(cellsPassed * 2, j) + 1.0) * 8.0)))
		tiles[levelWidth - 1][j] = tileval
		tileImgs[levelWidth - 1][j] = tileImgSelect(tileval)
		tilemap.set_cell(levelWidth - 1, j, tileImgs[levelWidth - 1][j])
		# print(tileval)
		if tileval == 1:
			var treeNode = tree.instance()
			treeNode.set_position(Vector2((levelWidth) * 64 + 32, j * 64))
			add_child(treeNode)
	cellsPassed += 1

func initNoise():
	var randgen = RandomNumberGenerator.new()
	randgen.randomize()
	noise.seed = 0
	noise.lacunarity = 2.0
	noise.octaves = 3
	noise.period = 13.0
	noise.persistence = 0.8

func tileBias(val):
	#land
	if val <= 6:
		return 0
	#tree
	elif val <= 8:
		return 1
	#water
	elif val <= 16:
		return 2

func tileImgSelect(val):
	match val:
		0, 1:
			#select tree
			return rng.randi_range(0, 18)
		2:
			#select water
			return rng.randi_range(19, 51)
		
func snap(scroll):
	for ent in MultiplayerManager.in_world:
		ent.bounce_back(-scroll)
