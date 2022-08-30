# Este script va en el tilemap y hace que varios autotiles se puedan mezclar entre si
# Usado para la iglesia
tool
extends TileSet

const TILE_1: int = 0
const TILE_2: int = 1

var binds := {
	TILE_1 : [TILE_2],
	TILE_2 : [TILE_1],
}

func _is_tile_bound(drawn_id: int, neighbor_id: int) -> bool:
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
