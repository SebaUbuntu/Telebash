# HomeBot

### A modular Telegram bot, written on Bash

### How to use it...

- Launch `install.sh` to install all the dependencies

- Put a bot token in `variables.sh`

- Edit additional variables in `variables.sh`

#### As a bot:

- Launch the bot by typing 

  ```bash
  ./start.sh
  ```

#### As a wrapper (do stuff from CLI or other scripts)

* Source all functions and variables with

  ```bash
  source base/telegram.sh
  ```

### Features

- Module-based, so you can add and remove modules as you like
- Easy to understand (after all, it's Bash, no?)
- A wrapper with multiple functions is included to send and receive informations from Telegram

### Modules included:

- weather | Get weather updates of a city
- speedtest | Test bot's Internet connection speed
- CI | Automated CI system, you can trigger AOSP custom ROMs and custom recoveries building, with progress updating
- cowsay
- neofetch
- And more...

## Want to see how this bot works or you want to create a module for this bot?

Head over to [the wiki](https://github.com/SebaUbuntu/HomeBot/wiki) for more informations