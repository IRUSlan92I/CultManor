extends AbstractLevel


func _ready() -> void:
	super._ready()
	$Objects/LeverDoor.switching.connect($Doors/LeverDoor.toggle)
	$Objects/LeverDoor.switching.connect($ConnectionCables/ConnectionCableDoor.toggle)
	
	$Objects/LeverPlatform.switching.connect($Platforms/ColorSwitchingPlatform.toggle)
	$Objects/LeverPlatform.switching.connect($ConnectionCables/ConnectionCablePlatform.toggle)
	
	$Objects/LeverMoving.switching.connect($Platforms/SelfMovingPlatform.toggle)
	
	$Platforms/HiddenColorPlatform.set_player(player)
