open Bigarray

type 'kind buffer = ('a, 'b, c_layout) Array1.t
  constraint 'kind = ('a, 'b) kind

type float32 = (float, float32_elt) kind
type int8 = (int, int8_unsigned_elt) kind

val png : string -> w:int -> h:int -> c:int -> int8 buffer -> unit
val bmp : string -> w:int -> h:int -> c:int -> int8 buffer -> unit
val tga : string -> w:int -> h:int -> c:int -> int8 buffer -> unit
val hdr : string -> w:int -> h:int -> c:int -> float32 buffer-> unit
