(* This Source Code Form is subject to the terms of the Mozilla Public License,
   v. 2.0. If a copy of the MPL was not distributed with this file, You can
   obtain one at https://mozilla.org/MPL/2.0/ *)

module Email : sig
  exception Invalid_email

  type t [@@deriving show]

  val make : string -> (t, exn) result
end = struct
  exception Invalid_email

  type t = Emile.address [@@deriving show]

  let make email =
    let maked_email = Emile.address_of_string email in
    match maked_email with
    | Ok address -> Ok address
    | Error _ -> Error Invalid_email
end

module Hash : sig
  exception Invalid_password

  type t

  val make : ?count:int -> ?seed:string -> string -> t
  val verify : string -> t -> (bool, exn) result
  val show : t -> string
  val pp : Format.formatter -> t -> unit
  val of_string : string -> t
end = struct
  exception Invalid_password

  type t = Bcrypt.hash

  let make = Bcrypt.hash ~variant:Bcrypt.Y

  let verify password hash =
    if Bcrypt.verify password hash then Ok true else Error Invalid_password

  let show = Bcrypt.string_of_hash
  let pp ppf hash = Format.pp_print_string ppf (show hash)
  let of_string = Bcrypt.hash_of_string
end

module Uuid : sig
  exception Invalid_uuid

  type t

  val v4_gen : Random.State.t -> unit -> t
  val show : t -> string
  val pp : Format.formatter -> t -> unit
  val make : string -> (t, exn) result
end = struct
  exception Invalid_uuid

  include Uuidm

  let make uuid_string =
    Uuidm.of_string uuid_string |> Option.to_result ~none:Invalid_uuid

  let show u = to_string u
end

module Member : sig
  type t = {
    id : Uuid.t;
    username : string option;
    email : Email.t;
    hash : Hash.t;
  }
  [@@deriving make, show]

  val id : t -> Uuid.t
  val username : t -> string option
  val email : t -> Email.t
  val hash : t -> Hash.t
end = struct
  type t = {
    id : Uuid.t;
    username : string option;
    email : Email.t;
    hash : Hash.t;
  }
  [@@deriving make, show]

  let id member = member.id
  let username member = member.username
  let email member = member.email
  let hash member = member.hash
end
