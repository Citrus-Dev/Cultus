# Estela para ataques hitscan que desaparece automaticamente
class_name Tracer
extends Line2D

var tween: Tween
var duracion: float

func _init(inicio: Vector2, final: Vector2, nueva_duracion: float) -> void:
    add_point(inicio)
    add_point(final)

    tween = Tween.new()
    duracion = nueva_duracion


func _ready() -> void:
    add_child(tween)
    tween.interpolate_property(
        self,
        "modulate:a",
        modulate.a,
        0.0,
        duracion
    )
    tween.start()

    yield(tween, "tween_all_completed")

    call_deferred("free")
