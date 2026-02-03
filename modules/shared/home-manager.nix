{ pkgs, lib, ... }:

let
  name = "Edoardo Debenedetti";
  user = "edoardo";
  email = "edoardo.m.debenedetti@gmail.com";
in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    plugins = [ ];

    shellAliases = with pkgs; {
      # Other
      ".." = "cd ..";
      ":q" = "exit";
      cat = "${bat}/bin/bat";
      du = "${dust}/bin/dust";
      ls = "${eza}/bin/eza";
      la = "ll -a";
      ll = "ls -l --time-style long-iso --icons";
      tb = "toggle-background";
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      python = "python3";
      diff = "difft";
      search = "rg -p --glob '!node_modules/*'  $@";
    };

    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH
      export PATH=$HOME/.local/bin:$PATH
      export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }
    '';
  };

  nushell = {
    enable = false;
    # for editing directly to config.nu
    extraConfig = ''
      let carapace_completer = {|spans|
          carapace $spans.0 nushell ...$spans | from json
      }
      let zoxide_completer = {|spans|
          $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
      }

      let multiple_completers = {|spans|
          match $spans.0 {
              z => $zoxide_completer
              _ => $carapace_completer
          } | do $in $spans
      }

      $env.config = {
          show_banner: false,
          completions: {
          case_sensitive: false # case-sensitive completions
          quick: true    # set to false to prevent auto-selecting completions
          partial: true    # set to false to prevent partial filling of the prompt
          algorithm: "fuzzy"    # prefix or fuzzy
          external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
              enable: true
              # set to lower can improve completion performance at the cost of omitting some options
              max_results: 100
              completer: $multiple_completers # check 'carapace_completer'
            }
          }
      }
      $env.PATH = ($env.PATH | split row (char esep) | append $"($env.HOME)/.local/bin")
    '';
    shellAliases = {
      vi = "hx";
      vim = "hx";
      nano = "hx";
    };
  };

  carapace = {
    enable = true;
  };

  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  delta = {
    enable = true;
    enableGitIntegration = true;
  };

  git = {
    enable = true;
    ignores = [
      "*.swp"
      ".DS_Store"
    ];

    lfs.enable = true;

    settings = {
      user.name = name;
      user.email = email;
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      diff.external = "difft";
      commit.gpgsign = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-startify
      vim-tmux-navigator
    ];
    settings = {
      ignorecase = true;
    };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/.local/share/src',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
    '';
  };

  ssh = {
    enable = true;
    enableDefaultConfig = false;

    includes = [
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux "/home/${user}/.ssh/config_external")
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "/Users/${user}/.ssh/config_external")
    ];
    matchBlocks = {
      "*" = {
        controlPath = "~/.ssh/%C"; # ensures the path is unique but also fixed length
        serverAliveInterval = 300;
        serverAliveCountMax = 12;
      };

      "github.com" = {
        identitiesOnly = true;
        identityFile = "~/.ssh/id_ed25519";
      };
      "euler privsec0 privsec1 spylab0 spylab1 jumphost.inf.ethz.ch" =
        lib.hm.dag.entryBefore [ "euler" "privsec0" "privsec1" "jumphost.inf.ethz.ch" ]
          {
            user = "edebenedetti";
            identityFile = "~/.ssh/id_ed25519_euler";
            forwardX11 = true;
            forwardX11Trusted = true;
          };
      "euler privsec0 privsec1 spylab0 spylab1" =
        lib.hm.dag.entryBefore [ "euler" "privsec0" "privsec1" "spylab0" "spylab1" ]
          {
            proxyJump = "jumphost.inf.ethz.ch";
          };
      "euler" = {
        hostname = "login.euler.ethz.ch";
      };
      "privsec0" = {
        hostname = "privsec0.inf.ethz.ch";
      };
      "privsec1" = {
        hostname = "privsec1.inf.ethz.ch";
      };
      "spylab0" = {
        hostname = "spylab0.inf.ethz.ch";
      };
      "spylab1" = {
        hostname = "spylab1.inf.ethz.ch";
      };
      "lassen" = {
        hostname = "lassen.llnl.gov";
        user = "debenede";
      };
      "ela clariden" = lib.hm.dag.entryBefore [ "ela" "clariden" ] {
        user = "edebened";
        identityFile = "~/.ssh/cscs-key";
        forwardAgent = true;
      };
      "ela" = lib.hm.dag.entryBefore [ "clariden" ] {
        hostname = "ela.cscs.ch";
      };
      "clariden" = lib.hm.dag.entryBefore [ "clariden" ] {
        proxyJump = "ela";
        hostname = "clariden.cscs.ch";
      };
    };
  };

  tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs.tmuxPlugins; [
      yank
      prefix-highlight
      {
        plugin = power-theme;
        extraConfig = ''
          set -g @tmux_power_theme 'gold'
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

    '';
  };

  starship = {
    enable = true;
    settings = {
      # See docs here: https://starship.rs/config/
      directory.truncation_length = 2; # number of directories not to truncate
      gcloud.disabled = true; # annoying to always have on
      hostname.style = "bold green"; # don't like the default
      memory_usage.disabled = true; # because it includes cached memory it's reported as full a lot
      shlvl.disabled = false;
      username.style_user = "bold blue"; # don't like the default
    };
  };

  atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  helix = {
    enable = true;
    settings = {
      theme = "onedark";
    };
  };
}
