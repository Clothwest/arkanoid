class_name RecoverableBrickData extends SpecialBrickData

@export var recovery_cooldown: float

func get_recovered_level(current_level: int) -> void:
	return maxi(0, current_level - 1)
