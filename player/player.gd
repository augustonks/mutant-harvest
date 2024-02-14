class_name Player
extends CharacterBody2D

var stamina: int = 100
@export
var speed := 100

@export
var tilemap: TileMap

@onready
var item_manager := $ItemManager
@onready
var camera: Camera2D = get_node_or_null("Camera2D")

func _ready():
	item_manager.tilemap = tilemap


func _physics_process(_delta):
	move_and_slide()
