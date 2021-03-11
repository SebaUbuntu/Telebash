# Telebash
## A modular Telegram wrapper/bot, written on Bash
This wrapper allows you to easily interact with Telegram bot APIs.

Sourcing `base/telegram.sh` will give you the command `telegram`, which you can use together with all available API methods (https://core.telegram.org/bots/api#available-methods).

You can also use this wrapper as a bot (the script will process every new update got with getUpdates method); a module manager and some modules are provided.

## Usage
### Setup
- Launch `install.sh` to install all the dependencies

- Put a bot token in `variables.sh`

- Edit additional variables in `variables.sh`

#### Use as a wrapper (do stuff from CLI or other scripts)
* Source all functions and variables with

  ```bash
  source base/telegram.sh
  ```

#### Use as a bot:
- Launch the bot by typing 

  ```bash
  ./start.sh
  ```

### Features
#### General
- Easy to understand (after all, it's Bash, no?)

#### Wrapper
- A wrapper with multiple functions is included to send and receive informations from Telegram

#### Bot
- Module-based, so you can add and remove modules as you like

##### Modules included:
- weather | Get weather updates of a city
- speedtest | Test bot's Internet connection speed
- CI | Automated CI system, you can trigger AOSP custom ROMs and custom recoveries building, with progress updating
- cowsay
- neofetch
- And more...

## Wiki
Want to see how this bot works or you want to create a module for this bot?

Head over to [the wiki](https://github.com/SebaUbuntu/Telebash/wiki) for more informations
