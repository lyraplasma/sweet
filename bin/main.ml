let () =
  let info = Info.collect () in
  Printf.printf "<><><><><><> Your Machine's Status :3 <><><><><><>\n";
  Printf.printf "\t\tOS:        %s\n" info.Info.os;
  Printf.printf "\t\tHostname:  %s\n" info.Info.hostname;
  Printf.printf "\t\tKernel:    %s\n" info.Info.kernel;
  Printf.printf "\t\tUptime:    %s\n" info.Info.uptime;
  Printf.printf "\t\tPackages:  %s\n" info.Info.packages;
  Printf.printf "\t\tShell:     %s\n" info.Info.shell;
  Printf.printf "\t\tCPU:       %s\n" info.Info.cpu;
  Printf.printf "\t\tGPU:       %s\n" info.Info.gpu;
  Printf.printf "\t\tMemory:    %s\n" info.Info.memory;
  Printf.printf "\t\tDisk:      %s\n" info.Info.disk
