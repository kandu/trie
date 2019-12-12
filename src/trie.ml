open Core_kernel
open Fn

module type intf = sig
  type path
  type 'a node
  val create : 'a option -> 'a node
  val get : 'a node -> path list -> 'a option
  val set : 'a node -> path list -> 'a -> unit
  val unset : 'a node -> path list -> unit
  val sub: 'a node -> path list -> 'a node option
end

module Make (H:Hashtbl.Key): (intf with type path:= H.t) = struct
  module Path = Hashtbl.Make(H)
  type 'a node= {
    mutable value: 'a option;
    next: 'a node Path.t
  }

  let create value= { value; next= Path.create () }

  let append ?(value=None) node key=
    Path.find_or_add node.next key
      ~default:(fun ()->
        let child= create value in
        Path.set node.next ~key ~data:child;
        child)

  let rec set node path value=
    match path with
    | []-> node.value <- Some value
    | hd::tl-> match Path.find node.next hd with
      | Some child-> set child tl value
      | None-> set (append node hd) tl value

  let rec get node path=
    match path with
    | []-> node.value
    | hd::tl-> match Path.find node.next hd with
      | Some child-> get child tl
      | None-> None

  let unset node path=
    let rec unset node path=
      match path with
      | []-> node.value <- None; true
      | hd::tl-> match Path.find node.next hd with
        | Some child->
          if unset child tl then
            if Path.is_empty child.next && child.value = None
            then (Path.remove node.next hd; true)
            else false
          else false
        | None-> false
    in unset node path |> ignore

  let rec sub node path=
    match path with
    | []-> Some node
    | hd::tl-> match Path.find node.next hd with
      | Some child-> sub child tl
      | None-> None
end

