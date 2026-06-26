let () =
  let info = Info.collect () in
  Printf.printf "OS:        %s\n" info.Info.os;
  Printf.printf "Hostname:  %s\n" info.Info.hostname;
  Printf.printf "Kernel:    %s\n" info.Info.kernel;
  Printf.printf "Uptime:    %s\n" info.Info.uptime;
  Printf.printf "Packages:  %s\n" info.Info.packages;
  Printf.printf "Shell:     %s\n" info.Info.shell;
  Printf.printf "CPU:       %s\n" info.Info.cpu;
  Printf.printf "GPU:       %s\n" info.Info.gpu;
  Printf.printf "Memory:    %s\n" info.Info.memory;
  Printf.printf "Disk:      %s\n" info.Info.disk
