(* This Source Code Form is subject to the terms of the Mozilla Public License,
      v. 2.0. If a copy of the MPL was not distributed with this file, You can
      obtain one at https://mozilla.org/MPL/2.0/ *)
let hello_handler _request =
  let open Yojson.Safe in
  Dream.json @@ to_string @@ `Assoc [("message", `String "hello world")]

let routes = [Dream.get "/" hello_handler]
