{
  self,
  lib,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "ft_nvim";
  version = self.rev or self.dirtyRev or "unknown";
  src = ../..;
  meta = {
    description = "A Neovim plugin for École 42";
    homepage = "https://github.com/vinicius507/ft_nvim";
    license = lib.licenses.mit;
  };
}
