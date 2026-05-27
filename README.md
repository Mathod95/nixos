# Packages

| PACKAGE                                                   | CORE | VM   | WSL  | LAPTOP | DESKTOP | CONFIG | COMMENT |
|-----------------------------------------------------------|:----:|:----:|:----:|:------:|:-------:|:------:|:-------:|
|**flakes**                                                 | ![Yes][yes]   |      |      |        |         |        |         |
|**nix-command**                                            | ✅  |      |      |        |         |        |         |
|**git**                                                    |      |      |      |        |         |        |         |
|**[eza](https://github.com/eza-community/eza)**            |      |      |      |        |         |        |         |
|**[zsh](https://github.com/zsh-users/zsh)**                |      |      |      |        |         |        |         |
|**[vim](https://github.com/vim/vim)**                      |      |      |      |        |         |        |         |
|**[bat](https://github.com/sharkdp/bat)**                  |      |      |      |        |         |        |         |
|**[btop](https://github.com/aristocratos/btop)**           |      |      |      |        |         |        |         |
|**[fastfetch](https://github.com/fastfetch-cli/fastfetch)**|      |      |      |        |         |        |         |
|**[zsh](https://github.com/zsh-users/zsh)**                |      |      |      |        |         |        |         |
|**[zellij](https://github.com/zellij-org/zellij)**         |      |      |      |        |         |        |         |
|**[vscode](https://github.com/microsoft/vscode)**          |      |      |      |        |         |        |         |
|**[fd](https://github.com/sharkdp/fd)**                    |      |      |      |        |         |        |         |
|**[fzf](https://github.com/junegunn/fzf)**                 |      |      |      |        |         |        |         |
|**[helm](https://github.com/helm/helm)**                   |      |      |      |        |         |        |         |
|**[kubectl](https://github.com/kubernetes/kubectl)**       |      |      |      |        |         |        |         |
|**[kctx](https://github.com/ahmetb/kubectx)**              |      |      |      |        |         |        |         |
|**[k9s](https://github.com/derailed/k9s)**                 |      |      |      |        |         |        |         |
|**[kubecolor](https://github.com/kubecolor/kubecolor)**    |      |      |      |        |         |        |         |
|**(steam)**                                                |      |      |      |        |         |        |         |
|**(whatsapp)**                                             |      |      |      |        |         |        |         |
|**(telegram)**                                             |      |      |      |        |         |        |         |
|**(discord)**                                              |      |      |      |        |         |        |         |
|**(plex)**                                                 |      |      |      |        |         |        |         |
|**(spotify)**                                              |      |      |      |        |         |        |         |
|**(ghostty)**                                              |      |      |      |        |         |        |         |
|                                                           |      |      |      |        |         |        |         |
|                                                           |      |      |      |        |         |        |         |
|                                                           |      |      |      |        |         |        |         |
|                                                           |      |      |      |        |         |        |         |
|                                                           |      |      |      |        |         |        |         |
|                                                           |      |      |      |        |         |        |         |
|                                                           |      |      |      |        |         |        |         |



# Todo

- git
  - config user:mail
- zsh
  - import my config


- sops-nix
- cachix
- LUKS

## Commands 

<details>
<summary><b>WSL</b></summary>

``` powershell title="Delete WSL"
wsl --unregister NixOS
```
</details>

<details>
<summary><b>SSH</b></summary>

``` bash title="Create SSH key"
ssh-keygen -t ed25519 -C "NixOS" -f $HOME/.ssh/nixos
```
</details>

<details>
<summary><b>NIX</b></summary>

``` nix title="bootstrap from github"
sudo nix --extra-experimental-features "nix-command flakes" run nixpkgs#nixos-rebuild -- switch --flake github:Mathod95/nixos#<configuration>
```

``` nix title="Update from github"
sudo nix --extra-experimental-features "nix-command flakes" run nixpkgs#nixos-rebuild -- switch --flake github:Mathod95/nixos#wsl --refresh
```
</details>

---