## What is Cocos OS?

CocosOS is a minimalist and experimental 32-bit operating system designed to revive old computers, but I'm working on a 64-bit version and plan to upload it to another repository within a month.

It's designed as a laboratory of ideas, featuring integrated apps, a GUI like GNOME Shell with scripting in Lua 5.4, But it's being changed to make it more practical for everyday use.

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/david-tech-404/CocosOS)

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

Main Maintainer: David Fernández (insha'allah Corralejo)

This open-source project is currently maintained by a single person.

- Reddit: u/Daviddandadan
- Discord: https://discord.gg/mEZwx7rNbn

## Contributions

Contributions are open :D so read CONTRIBUTING.MD

## License

The system kernel (such as /kernel, /core, /boot, etc.) is licensed under the GPLv3 license.

The APIs, the UI/GUI (also known as the graphical user interface), and the apps are licensed under the MIT license.

## When will it be ready?

The code is already ready, which is why it's on GitHub.

## Who is David?

David (that's me) is the one who wrote all of this and who created the entire Cocos OS system.

**You can just call me David Tech or just David**

# How to compile the code
Prerequisites:
**Before compiling,**  **ensure you have the following tools installed:**

NASM (Assembler)

GCC (i686-elf cross-compiler recommended)

Binutils (ld linker)

Make (Build automation)

QEMU (To run the OS)

On Ubuntu/Debian: sudo apt install build-essential nasm qemu-system-x86 mtools

Steps:

1 Run: make

Wait a long or short time depending on your computer

2 (Optional for running a VM in QEMU) Run: make run

Done! :D

# Why I started this project
For two reasons:
1 - For complete privacy
2 - So that the user can have more control

## Copyright

© 2025-2026 David

Cocos OS uses a dual-license model:

- Core system: GPLv3
- Application and UI: MIT
