(* This Source Code Form is subject to the terms of the Mozilla Public License,
      v. 2.0. If a copy of the MPL was not distributed with this file, You can
      obtain one at https://mozilla.org/MPL/2.0/ *)

module MemberServive = Service.Member (Repository.Member)

let hello_handler _request =
  let open Yojson.Safe in
  Dream.json @@ to_string @@ `Assoc [("message", `String "hello world")]

let signup_handler request =
  let open Yojson.Safe.Util in
  let open Util.LwtSyntax in
  let* body = Dream.body request in
  let json_res =
    try Ok (Yojson.Safe.from_string body) with
    | Failure _ -> Error "Invaild JSON Body" in
  match json_res with
  | Error e ->
    Dream.json ~status:`Bad_Request
    @@ to_string
    @@ `Assoc [("message", `String e)]
  | Ok json -> (
    let email = json |> member "email" |> to_string
    and password = json |> member "password" |> to_string in
    let* signup_result =
      Dream.sql request @@ MemberServive.signup ~email ~password in
    match signup_result with
    | Error e ->
      Dream.json ~status:`Forbidden
      @@ to_string
      @@ `Assoc [("message", `String e)]
    | Ok _ ->
      Dream.json ~status:`Created
      @@ to_string
      @@ `Assoc [("message", `String "Created")])

(** Singnin route *)
let signin_handler request =
  let open Yojson.Safe.Util in
  let open Util.LwtSyntax in
  let* body = Dream.body request in
  let json_res =
    try Ok (Yojson.Safe.from_string body) with
    | Failure _ -> Error "Invaild JSON Body" in
  match json_res with
  | Error e ->
    Dream.json ~status:`Bad_Request
    @@ to_string
    @@ `Assoc [("message", `String e)]
  | Ok json -> (
    let email = json |> member "email" |> to_string
    and password = json |> member "password" |> to_string in
    let* signin_result =
      Dream.sql request @@ MemberServive.signin ~email ~password in
    match signin_result with
    | Error e ->
      Dream.json ~status:`Forbidden
      @@ to_string
      @@ `Assoc [("message", `String e)]
    | Ok jwt ->
      Dream.json ~status:`OK @@ to_string @@ `Assoc [("token", `String jwt)])

let routes = [Dream.get "/" hello_handler; Dream.post "/signup" signup_handler]
