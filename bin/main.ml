let has_flag f =
  List.exists ((=) f) (List.tl (Array.to_list Sys.argv))

let version = "sweet 1.0"

let () =
  let info = Info.collect () in

  if has_flag "-v" then
    Printf.printf "%s\n" version
  else if has_flag "-f" then
    begin
      Printf.printf "<><><><><><> Your Machine's Status :3 <><><><><><>\n";
      Printf.printf "\t\tOS:        %s\n" info.os;
      Printf.printf "\t\tHostname:  %s\n" info.hostname;
      Printf.printf "\t\tKernel:    %s\n" info.kernel;
      Printf.printf "\t\tUptime:    %s\n" info.uptime;
      Printf.printf "\t\tPackages:  %s\n" info.packages;
      Printf.printf "\t\tShell:     %s\n" info.shell;
      Printf.printf "\t\tCPU:       %s\n" info.cpu;
      Printf.printf "\t\tGPU:       %s\n" info.gpu;
      Printf.printf "\t\tMemory:    %s\n" info.memory;
      Printf.printf "\t\tDisk:      %s\n" info.disk
    end
  else
    begin
      Printf.printf "OS:        %s\n" info.os;
      Printf.printf "Hostname:  %s\n" info.hostname;
      Printf.printf "Kernel:    %s\n" info.kernel;
      Printf.printf "Uptime:    %s\n" info.uptime;
      Printf.printf "Packages:  %s\n" info.packages;
      Printf.printf "Shell:     %s\n" info.shell;
      Printf.printf "CPU:       %s\n" info.cpu;
      Printf.printf "GPU:       %s\n" info.gpu;
      Printf.printf "Memory:    %s\n" info.memory;
      Printf.printf "Disk:      %s\n" info.disk
    end
