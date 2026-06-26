type t = {
  os        : string;
  hostname  : string;
  kernel    : string;
  uptime    : string;
  packages  : string;
  shell     : string;
  cpu       : string;
  gpu       : string;
  memory    : string;
  disk      : string;
}

let get_os () =
  try
    let ic = open_in "/etc/os-release" in
    let rec loop () =
      try
        let line = input_line ic in
        if String.starts_with ~prefix:"PRETTY_NAME=" line then
          let value = String.sub line 13 (String.length line - 14) in
          close_in ic; String.trim value
        else loop ()
      with End_of_file -> close_in ic; Sys.os_type
    in
    loop ()
  with _ -> Sys.os_type

let get_hostname () = Unix.gethostname ()

(* FIXED: use the external `uname` command instead of Unix.uname *)
let get_kernel () =
  try
    let ic = Unix.open_process_in "uname -s -r 2>/dev/null" in
    let line = input_line ic in
    let _ = Unix.close_process_in ic in
    String.trim line
  with _ -> Sys.os_type

let get_uptime () =
  try
    let ic = open_in "/proc/uptime" in
    let line = input_line ic in
    close_in ic;
    let secs = float_of_string (String.split_on_char ' ' line |> List.hd) in
    let days = truncate (secs /. 86400.0) in
    let hours = truncate (mod_float secs 86400.0 /. 3600.0) in
    let mins = truncate (mod_float secs 3600.0 /. 60.0) in
    if days > 0 then Printf.sprintf "%dd %dh %dm" days hours mins
    else if hours > 0 then Printf.sprintf "%dh %dm" hours mins
    else Printf.sprintf "%dm" mins
  with _ -> "N/A"

let get_packages () =
  let count_cmd cmd =
    try
      let ic = Unix.open_process_in (cmd ^ " 2>/dev/null | wc -l") in
      let line = input_line ic in
      let _ = Unix.close_process_in ic in
      String.trim line
    with _ -> "?"
  in
  if Sys.file_exists "/var/lib/dpkg/status" then
    count_cmd "dpkg --list" ^ " (dpkg)"
  else if Sys.file_exists "/var/lib/pacman/local" then
    count_cmd "pacman -Q" ^ " (pacman)"
  else if Sys.file_exists "/var/lib/rpm" then
    count_cmd "rpm -qa" ^ " (rpm)"
  else "Unknown"

let get_shell () =
  match Sys.getenv "SHELL" with
  | path -> Filename.basename path
  | exception Not_found -> "Unknown"

let get_cpu () =
  try
    let ic = open_in "/proc/cpuinfo" in
    let model = ref "Unknown" in
    let cores = ref 0 in
    let rec loop () =
      try
        let line = input_line ic in
        if String.starts_with ~prefix:"model name" line then
          let parts = String.split_on_char ':' line in
          if List.length parts >= 2 then
            model := String.trim (List.nth parts 1)
        else if String.starts_with ~prefix:"processor" line then
          incr cores;
        loop ()
      with End_of_file -> ()
    in
    loop ();
    close_in ic;
    Printf.sprintf "%s (%d cores)" !model !cores
  with _ -> "N/A"

let get_gpu () =
  try
    let ic = Unix.open_process_in "lspci | grep -i 'vga\\|3d\\|display' 2>/dev/null" in
    let line = input_line ic in
    let _ = Unix.close_process_in ic in
    match String.split_on_char ':' line with
    | _ :: rest -> String.concat ":" rest |> String.trim
    | _ -> line
  with _ -> "Not detected"

let get_memory () =
  try
    let ic = open_in "/proc/meminfo" in
    let total = ref 0 and avail = ref 0 in
    let rec loop () =
      try
        let line = input_line ic in
        if String.starts_with ~prefix:"MemTotal:" line then
          let parts = String.split_on_char ' ' line |> List.filter ((<>) "") in
          if List.length parts >= 2 then total := int_of_string (List.nth parts 1)
        else if String.starts_with ~prefix:"MemAvailable:" line then
          let parts = String.split_on_char ' ' line |> List.filter ((<>) "") in
          if List.length parts >= 2 then avail := int_of_string (List.nth parts 1);
        loop ()
      with End_of_file -> ()
    in
    loop ();
    close_in ic;
    if !total > 0 && !avail > 0 then
      let used = !total - !avail in
      Printf.sprintf "%d MiB / %d MiB" (used / 1024) (!total / 1024)
    else "N/A"
  with _ -> "N/A"

let get_disk () =
  try
    let stat = Unix.statvfs "/" in
    let total = stat.Unix.blocks * stat.Unix.bsize in
    let free = stat.Unix.bavail * stat.Unix.bsize in
    let used = total - free in
    Printf.sprintf "%d GiB / %d GiB" (used / (1024*1024*1024)) (total / (1024*1024*1024))
  with _ -> "N/A"

let collect () =
  {
    os = get_os ();
    hostname = get_hostname ();
    kernel = get_kernel ();
    uptime = get_uptime ();
    packages = get_packages ();
    shell = get_shell ();
    cpu = get_cpu ();
    gpu = get_gpu ();
    memory = get_memory ();
    disk = get_disk ();
  }
