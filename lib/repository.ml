(* This Source Code Form is subject to the terms of the Mozilla Public License,
      v. 2.0. If a copy of the MPL was not distributed with this file, You can
      obtain one at https://mozilla.org/MPL/2.0/ *)

module E = Infra.Environment
module D = Domain

module type MEMBER = sig
  type ('res, 'err) query_result =
    ('res, ([> Caqti_error.call_or_retrieve] as 'err)) result Lwt.t

  val get_by_email_hash :
    email:D.Email.t ->
    hash:D.Hash.t ->
    (module Rapper_helper.CONNECTION) ->
    (D.Member.t, ([> Caqti_error.call_or_retrieve] as 'err)) query_result

  val create :
    id:D.Uuid.t ->
    email:D.Email.t ->
    hash:D.Hash.t ->
    (module Rapper_helper.CONNECTION) ->
    (unit, ([> Caqti_error.call_or_retrieve] as 'err)) query_result

  val update :
    email:D.Email.t ->
    username:string option ->
    hash:D.Hash.t ->
    id:D.Uuid.t ->
    (module Rapper_helper.CONNECTION) ->
    (unit, ([> Caqti_error.call_or_retrieve] as 'err)) query_result
end

module Member : MEMBER = struct
  module Uuid = struct
    type t = D.Uuid.t

    let t =
      let encode uuid = Ok (D.Uuid.show uuid) in
      let decode uuid =
        D.Uuid.make uuid |> Result.map_error (fun _ -> "Invalid") in
      Caqti_type.(custom ~encode ~decode string)
  end

  module Email = struct
    type t = D.Email.t

    let t =
      let encode email = Ok (D.Email.show email) in
      let decode email =
        D.Email.make email |> Result.map_error (fun _ -> "Invalid") in
      Caqti_type.(custom ~encode ~decode string)
  end

  module Hash = struct
    type t = D.Hash.t

    let t =
      let encode hash = Ok (D.Hash.show hash) in
      let decode hash = Ok (D.Hash.of_string hash) in
      Caqti_type.(custom ~encode ~decode string)
  end

  type ('res, 'err) query_result =
    ('res, ([> Caqti_error.call_or_retrieve] as 'err)) result Lwt.t

  let get_by_email_hash_query =
    let open D.Member in
    [%rapper
      get_one
        {sql| 
          SELECT @Uuid{id}, @string?{username}, @Email{email},
          @Hash{hash} FROM "Member" WHERE email = %Email{email} AND hash =
          %Hash{hash}
          |sql}
        record_out]

  let create_query =
    [%rapper
      execute
        {sql|
          INSERT INTO "Member" (id, email, hash) VALUES  (%Uuid{id}, %Email{email}, %Hash{hash})
          |sql}]

  let update_query =
    [%rapper
      execute
        {sql|
          UPDATE "Member"
          SET (email, username, hash) = (%Email{email}, %string?{username}, %Hash{hash})
          WHERE id = %Uuid{id}
          |sql}]

  let get_by_email_hash = get_by_email_hash_query
  let create = create_query
  let update = update_query
end
