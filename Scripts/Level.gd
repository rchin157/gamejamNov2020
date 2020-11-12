extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tiles = []
var tileImgs = []
var currentScroll = 0

var levelHeight = 12
var levelWidth = 44
var cellwidth = 64
var scrollPeriod = 8
var cellsPassed = 24

var noise = OpenSimplexNoise.new()

var rng = RandomNumberGenerator.new()

var tree = load("res://Entities/Tree.tscn")
var pun = load("res://Entities/Beta.tscn")

var isSetPiece = false
var setPieceProgress = 20

onready var tilemap = get_node("TileMap")
onready var camera = get_node("Camera2D")

#Fuck me
var TLW = [19]
var TW = [20,21,22]
var TRW = [23]
var RW = [24,29,34]
var LW = [28,33,38]
var BLW = [39]
var BW = [40,41,42]
var BRW = [43]
var CW = [25,26,27,30,31,32,35,36,37,44,45,46,47,48,49]
var BUW = [26]
var LO = [59,53]
var RO = [52,58]
var TO = [56,57]
var BO = [54,55]
var CO = [62,63]
var LR = [74,75]
var TB = [72,73]

#var TLW = [12]
#var TW = [14]
#var TRW = [62]
#var RW = [22]
#var LW = [18]
#var BLW = [63]
#var BW = [36]
#var BRW = [61]
#var CW = [60]
#var BUW = [26]

#Fuck me harder
var spawnset = [[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[1,1,1,1,1,1,1,1,1,1,1,1], [1,1,1,1,1,1,1,1,1,1,1,1],
				[1,1,1,1,1,1,1,1,1,1,1,1], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[2,2,2,2,2,2,2,2,2,2,2,2], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [1,1,1,1,1,1,1,1,1,1,1,1],
				[1,1,1,1,1,1,1,1,1,1,1,1], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0]]
var island1 = [[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,1,1,0,0,0,0,0,0,0,0,0], [0,1,1,1,0,0,0,0,0,0,0,0],
				[1,1,1,1,1,0,0,0,0,0,0,0], [2,2,1,1,1,1,0,0,0,0,0,0],
				[2,2,2,1,1,1,1,0,0,0,0,0], [2,2,2,2,2,1,1,1,0,0,0,0],
				[2,2,2,2,2,1,0,1,1,0,0,0], [2,2,2,2,2,2,2,1,1,0,0,0],
				[2,2,2,2,2,2,0,1,1,0,0,0], [0,2,2,2,2,0,0,1,1,1,0,0],
				[0,2,2,2,2,1,1,1,1,1,0,0], [2,2,2,2,1,1,1,1,0,1,1,0],
				[2,2,2,0,0,1,1,1,1,1,0,0], [2,1,1,1,1,1,1,1,1,1,0,0],
				[1,1,1,1,1,1,1,1,1,0,0,0], [1,1,1,1,1,1,1,1,1,0,0,0],
				[1,1,1,1,1,1,1,0,1,1,0,0], [0,0,0,0,0,0,0,0,1,1,0,0],
				[1,0,0,0,0,0,0,1,1,1,1,0], [0,0,0,0,0,0,0,0,0,0,0,0]]
var island2 = [[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0,0,0,0,0]]
				
var setPieces = [spawnset, island1, island2]

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
		for j in range(levelHeight):
			tiles[i].append(-1)
			tileImgs[i].append(-1)
	for i in range(24):
		for j in range(levelHeight):
			var tileval = setPieces[0][i][j]
			tiles[i][j] = tileval
			tileImgs[i][j] = tileImgSelect(tileval)
			tilemap.set_cell(i, j, tileImgs[i][j])
			if tileval == 1:
				var treeNode = tree.instance()
				treeNode.set_position(Vector2(i * 64 + 32, j * 64))
				add_child(treeNode)
			if tileval == 0 and rng.randi_range(0, 50) == 10:
				var punode = pun.instance()
				punode.set_position(Vector2(i * 64 + 32, j * 64))
				add_child(punode)
	for i in range(2, levelWidth):
		for j in range(levelHeight):
			#Checks if it is water
			var watertile = checkWater(i - 2, j)
			if watertile != -1:
				#print(watertile)
				tileImgs[i - 2][j] = watertile
				tilemap.set_cell(i - 2,j,watertile) 
			

func newColumn():
	var front = levelWidth - 20
	for i in range(levelWidth - 1):
		for j in range(levelHeight):
			tiles[i][j] = tiles[i + 1][j]
			tileImgs[i][j] = tileImgs[i + 1][j]
			tilemap.set_cell(i, j, tileImgs[i][j])
	if isSetPiece:
		setPieceProgress -= 1
		if setPieceProgress == 0:
			isSetPiece = false
		return
	for j in range(levelHeight):
		var tileval = tileBias(int(round((noise.get_noise_2d(cellsPassed * 2, j) + 1.0) * 8.0)))
		tiles[front - 1][j] = tileval
		tileImgs[front - 1][j] = tileImgSelect(tileval)
		tilemap.set_cell(front - 1, j, tileImgs[front - 1][j])
		# print(tileval)
		if tileval == 1:
			var treeNode = tree.instance()
			treeNode.set_position(Vector2((front) * 64 + 32, j * 64))
			add_child(treeNode)
		if tileval == 0 and rng.randi_range(0, 50) == 10:
			var punode = pun.instance()
			punode.set_position(Vector2((front) * 64 + 32, j * 64 + 32))
			add_child(punode)
	for j in range(levelHeight):
		#Checks if it is water
		var watertile = checkWater(front - 2, j)
		if watertile != -1:
			#print(watertile)
			tileImgs[front - 2][j] = watertile
			tilemap.set_cell(front - 2,j,watertile) 
	cellsPassed += 1
	if cellsPassed % 40 == 0: #and rng.randi() % 2 == 0:
		print("SETPIECE ADDED")
		addSetpiece(1)
		isSetPiece = true
		setPieceProgress = 20

func checkWater(i: int, j: int):
	if(tiles[i][j] == 2):
		#left,up,right,down
		var neighbors = [false,false,false,false]
		#left
		neighbors[0] = i-1<0 or tiles[i-1][j] == 2
		#up
		neighbors[1] = j-1<0 or tiles[i][j-1] == 2
		#right
		neighbors[2] = i+1>=levelWidth or tiles[i+1][j] == 2
		#down
		neighbors[3] = j+1>=levelHeight or tiles[i][j+1] == 2
		
		var check = int(neighbors[0])+2*int(neighbors[1])+4*int(neighbors[2])+8*int(neighbors[3])
		var imageArr = CW;
		
		match check:
			#Temporary (no neighbor pool does not exist add it here
			0:
				imageArr = CO
				#LEFT ONLY
			1:
				imageArr = LO
				#TOP ONLY
			2:
				imageArr = TO
			3:
				imageArr = BRW
				#RIGHT ONLY
			4:
				imageArr = RO
			#LEFT AND RIGHT
			5:
				imageArr = LR
			6:
				imageArr = BLW
			7:
				imageArr = BW
				#ONLY BOTTOM
			8:
				imageArr = BO
			9:
				imageArr = TRW
			#TOP AND BOTTOM
			10:
				imageArr = TB
			#TOP BOTTOM AND LEFT
			11:
				imageArr = LW
			12:
				imageArr = TLW
			13:
				imageArr = TW
			14:
				imageArr = RW
			15:
				#print('you got a center')
				imageArr = CW
		return imageArr[rng.randi_range(0,imageArr.size()-1)]
	return -1;

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
	for i in range(MultiplayerManager.in_world.size() - 1, -1, -1):
		MultiplayerManager.in_world[i].bounce_back(-scroll)
		
func addSetpiece(id):
	var start = levelWidth - 20
	for i in range(start, levelWidth):
		for j in range(levelHeight):
			tiles[i][j] = setPieces[id][i - start][j]
			tileImgs[i][j] = tileImgSelect(tiles[i][j])
			print(tileImgs[i][j])
			tilemap.set_cell(i, j, tileImgs[i][j])
	renderSetpiece()

func renderSetpiece():
	for i in range(levelWidth - 20, levelWidth):
		for j in range(levelHeight):
			if tiles[i][j] == 1:
				var treeNode = tree.instance()
				treeNode.set_position(Vector2((i + 1) * 64 + 32, j * 64))
				add_child(treeNode)
			if tiles[i][j] == 0 and rng.randi_range(0, 50) == 10:
				var punode = pun.instance()
				punode.set_position(Vector2((i + 1) * 64 + 32, j * 64 + 32))
				add_child(punode)
	for i in range(levelWidth - 20, levelWidth):
		for j in range(levelHeight):
			#Checks if it is water
			var watertile = checkWater(i - 2, j)
			if watertile != -1:
				#print(watertile)
				tileImgs[i - 2][j] = watertile
				tilemap.set_cell(i - 2,j,watertile)
