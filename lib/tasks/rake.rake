def null_device
  Gem.win_platform? ? "/nul"  : "/dev/null"
end
