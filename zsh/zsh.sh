# add a function path
fpath=($ZSH/functions $ZSH/completions $fpath)

# Load all of the config files in ~/oh-my-zsh that end in .zsh
for config_file ($ZSH/lib/*.zsh) source $config_file

# Add all defined plugins to fpath
plugin=${plugin:=()}
for plugin ($plugins) fpath=($ZSH/plugins/$plugin $fpath)

# Load and run compinit
autoload -U compinit
compinit -i

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
  if [ -f $ZSH/custom/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH/custom/plugins/$plugin/$plugin.plugin.zsh
  elif [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done

# Load all of your custom configurations from custom/
for config_file ($ZSH/custom/*.zsh) source $config_file

# Load the theme
if [ ! "$ZSH_THEME" = ""  ]
then
  source "$ZSH/themes/$ZSH_THEME.zsh-theme"
fi

# vim:ft=zsh:
