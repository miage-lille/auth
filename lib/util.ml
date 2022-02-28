(* This Source Code Form is subject to the terms of the Mozilla Public License,
      v. 2.0. If a copy of the MPL was not distributed with this file, You can
      obtain one at https://mozilla.org/MPL/2.0/ *)
module Result = struct
  include Result

  module Syntax = struct
    let ( let* ) = Result.bind
    let ( let+ ) = Result.map
  end

  module Infix = struct
    let ( >>= ) = Result.bind
    let ( >|= ) = Result.map
  end
end