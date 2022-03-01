(* This Source Code Form is subject to the terms of the Mozilla Public License,
      v. 2.0. If a copy of the MPL was not distributed with this file, You can
      obtain one at https://mozilla.org/MPL/2.0/ *)
module ResultSyntax = struct
  let ( let* ) = Result.bind
  let ( let+ ) a b = Result.map b a
end

module ResultInfix = struct
  let ( >>= ) = Result.bind
  let ( >|= ) a b = Result.map b a
end

module LwtSyntax = struct
  let ( let* ) = Lwt.bind
  let ( let+ ) = Lwt.map
end
