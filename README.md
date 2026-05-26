# Packages

|PACKAGE|COMMON|VM|WSL|LAPTOP|DESKTOP|CONFIG|
|---|:---:|:---:|:---:|:---:|:---:|:---:|
|**flakes**|✅| configuration.nix |configuration.nix|||
|**nix-command**|✅| configuration.nix |configuration.nix|||
|**git**||||||
|**[eza](https://github.com/eza-community/eza)**||||||
|**[zsh](https://github.com/zsh-users/zsh)**||||||
|**[vim](https://github.com/vim/vim)**||||||
|**[bat](https://github.com/sharkdp/bat)**||||||
|**[btop](https://github.com/aristocratos/btop)**||||||
|**[fastfetch](https://github.com/fastfetch-cli/fastfetch)**||||||
|**[zsh](https://github.com/zsh-users/zsh)**||||||
|**[zellij](https://github.com/zellij-org/zellij)**||||||


# Todo

- sops-nix
- agenix
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
</details>

---