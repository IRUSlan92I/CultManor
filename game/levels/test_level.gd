extends AbstractLevel


func _ready() -> void:
	super._ready()
	$Objects/Lever.switching.connect($Doors/LeverDoor.toggle)
