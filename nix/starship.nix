{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = true;
      python.disabled = true;
      ruby.disabled = true;
      hostname.ssh_only = false;
      # hostname.style = "bold green";
      format = ''  $cmd_duration
$directory$git_branch
$character'';
    };
  };
}