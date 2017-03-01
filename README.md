### Installation

With [Vundle](https://github.com/VundleVim/Vundle.vim) simply add this to your .vimrc:

```
Plugin 'vmchale/tokei-vim'
```

Of couse, you'll need to install [tokei](https://github.com/Aaronepower/tokei/releases) as well. 

Because it runs tokei in your current working directory, you're probably going to want a plugin to change the root directory appropriately. I use [vim-rooter](https://github.com/airblade/vim-rooter). 

### Usage

By default, tokei-vim provides a command and a keybinding:

```
:Tokei
<silent> co
```

You can also set `g_tokei_exlude` to exlude a file or pattern; tokei follows the as a .gitignore. If you wish to exclude two patterns, separate them with a comma with no spaces, e.g.

```
let g_tokei_exclude=TODO.md,README.md
```
