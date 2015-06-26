module type intf =
  sig
    type path
    type 'a node
    val create : 'a option -> 'a node
    val get : 'a node -> path list -> 'a option
    val set : 'a node -> path list -> 'a -> unit
    val unset : 'a node -> path list -> unit
    val sub: 'a node -> path list -> 'a node option
  end
module Make :
  functor (H : Core_kernel.Std.Hashtbl.Key) ->
    sig
      type 'a node
      val create : 'a option -> 'a node
      val get : 'a node -> H.t list -> 'a option
      val set : 'a node -> H.t list -> 'a -> unit
      val unset : 'a node -> H.t list -> unit
      val sub: 'a node -> H.t list -> 'a node option
    end
