extends CharacterBody2D

var stamina: int = 100
@export var speed := 100

@export var tilemap: TileMap

@onready var item_manager := $ItemManager

func _ready():
	item_manager.tilemap = tilemap

func _physics_process(_delta):
	move_and_slide()

