class_name ItemData
extends Resource

@export
var name: String
@export
var texture: Texture2D
@export
var type: String
@export
var crop: ItemData
@export
var stockable: bool = true
@export
var properties = {
	"seed_stages": 0,
	"cost": 0
}
