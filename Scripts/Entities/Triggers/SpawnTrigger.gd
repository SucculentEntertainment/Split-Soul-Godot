extends Position2D

onready var def = get_node("/root/Definitions")

var threshold = 0

var enabled = true
var initialized = false
var level = null
var player = null

var layer = ""
var rng = RandomNumberGenerator.new()
var spawnTable = []

var onCooldown = false

# ================================
# Init
# ================================

func _ready():
	$Timer.connect("timeout", self, "_onTimeout")

func initialize(level, player, layer):
	self.level = level
	self.player = player
	self.layer = layer
	
	createSpawnTable(level.levelID)
	$Timer.wait_time = def.LEVEL_DATA[level.levelID].spawnCooldown
	threshold = def.LEVEL_DATA[level.levelID].spawnThreshold
	
	$Timer.start()
	onCooldown = true
	initialized = true

func createSpawnTable(levelID):
	var i = 0
	
	for s in def.LEVEL_DATA[levelID].spawns:
		for j in range(i, i + s.chance):
			spawnTable.append(s.id)
			i += 1
			
			if i > 100:
				return

# ================================
# Update
# ================================

func _process(_delta):
	if !initialized: return
	if !enabled: return
	
	if position.distance_to(player.get_position()) / level.get_node("SpawnMaps/d_alive/Tiles").cell_size.x <= threshold:
		spawn()

func spawn():
	if onCooldown: return
	if not $Clearance.get_overlapping_bodies().empty(): return
	
	rng.randomize()
	var spawnID = spawnTable[rng.randi_range(0, 99)]
	
	if spawnID != "none":
		var spawnHelper = level.get_node("SpawnHelper")
		spawnHelper.spawn(spawnID, spawnHelper.posToCoords(position / level.get_node("Tiles").scale), Vector2(1, 1), "", level.currentDimensionID)
	
	onCooldown = true
	$Timer.start()

# ================================
# Events
# ================================

func _onTimeout():
	onCooldown = false

func changeDimension(dimension):
	if dimension == layer:
		enabled = true
		show()
	else:
		enabled = false
		hide()
