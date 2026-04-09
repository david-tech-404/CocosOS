# Cocos OS

An experimental and minimalist operating system.

## What is Cocos OS?

Cocos OS is an experimental operating system focused on simplicity, modularity, and complete system control.

It's designed as a laboratory of ideas, featuring integrated apps, a GUI like GNOME Shell with scripting in Lua 5.4.

## Cocos OS Status

Status: Under development, not very active; it's not a production-ready system; it's in beta or alpha.

## Technologies

The technologies used in Cocos OS are quite simple:

- Lua for apps and 100% of the logic
- C for the Cocos_engine and the Cocos OS kernel, and ASM for drivers
- ASM for switch.asm, irq0, some IDT, boot and bootstrap, and C for drivers
- JSON for configuration and Shellby AI
- Python and Swift for Shellby logic

## The Author and Maintenance

Main Maintainer: David Fernández (God willing, Corralejo)

This open-source project is currently maintained by a single person.

- Reddit: u/Daviddandadan
- Discord: https://discord.gg/mEZwx7rNbn

## Contributions

Contributions are not yet open, but clear rules will be published once the project is well established.

## License

The system core (such as /kernel, /core, /boot, etc.) is licensed under the GPLv3 license.

The APIs, UI/GUI (also known as the graphical interface), and applications are licensed under the MIT license.

## When will it be ready?

The code is already ready, which is why it's on GitHub.

## Who is David?

David (that's me) is the one who wrote all of this and who created the entire Cocos OS system.

**You can simply call me David Tech or just David.**

## Copyright

© 2025-2026 David

Cocos OS uses a dual-license model:

- Core system: GPLv3
- Application and UI: MIT
