(* This Source Code Form is subject to the terms of the Mozilla Public License,
      v. 2.0. If a copy of the MPL was not distributed with this file, You can
      obtain one at https://mozilla.org/MPL/2.0/ *)
open Infra.Log
open Util

module MemberServive = Service.Member (Repository.Member)
(** Bind dependencies *)

(** Heartbeat route *)
let hello_handler _request =
  let () = debug "Call hello_handler" in
  let open Yojson.Safe in
  Dream.json @@ to_string @@ `Assoc [("message", `String "hello world")]

(** echo the authorization header in body response; for testing purpose *)
let echo_handler request =
  let () = debug "Call echo_handler" in
  let open Yojson.Safe in
  match Dream.header request "Authorization" with
  | None -> Dream.json ~status:`Bad_Request "Authorization header required"
  | Some token ->
    Dream.json ~status:`OK @@ to_string @@ `Assoc [("token", `String token)]

(** Singnup route *)
let signup_handler request =
  let () = info "Call signup_handler" in
  let open Yojson.Safe.Util in
  let open LwtSyntax in
  let* body = Dream.body request in
  let json_res =
    try Ok (Yojson.Safe.from_string body) with
    | Failure _ -> Error "Invaild JSON Body" in
  match json_res with
  | Error e -> Dream.json ~status:`Bad_Request e
  | Ok json -> (
    let email = json |> member "email" |> to_string
    and password = json |> member "password" |> to_string in
    let* signup_result =
      Dream.sql request @@ MemberServive.signup ~email ~password in
    match signup_result with
    | Error e -> Dream.json ~status:`Forbidden e
    | Ok _ -> Dream.json ~status:`Created "")

(** Singnin route *)
let signin_handler request =
  let () = debug "Call signin_handler" in
  let open Yojson.Safe.Util in
  let open LwtSyntax in
  let* body = Dream.body request in
  let json_res =
    try Ok (Yojson.Safe.from_string body) with
    | Failure _ -> Error "Invaild JSON Body" in
  match json_res with
  | Error e -> Dream.json ~status:`Bad_Request e
  | Ok json -> (
    let email = json |> member "email" |> to_string
    and password = json |> member "password" |> to_string in
    let* signin_result =
      Dream.sql request @@ MemberServive.signin ~email ~password in
    match signin_result with
    | Error e -> Dream.json ~status:`Forbidden e
    | Ok jwt -> Dream.json ~status:`OK jwt)

let routes =
  [
    Dream.get "/" hello_handler;
    Dream.get "/echo" echo_handler;
    Dream.post "/signup" signup_handler;
    Dream.post "/signin" signin_handler;
  ]
