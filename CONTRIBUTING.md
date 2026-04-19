# Contributing to Cocos OS

Thank you for your interest in contributing to Cocos OS. Every contribution is appreciated.

## Getting Started

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test your changes properly
5. Submit a pull request

## Build Requirements

You need these tools installed:
- GCC or Clang
- NASM
- LD linker
- QEMU (for testing)
- GNU Make

## Automatic Dependency Installation

On Linux you can install all dependencies automatically:
```
sudo ./make.sh
```

## Supported Compilation Methods

| Method | Windows | Linux |
|---|---|---|
| `make` | ✅ | ✅ |
| `./build.sh` | ❌ | ✅ |

## Code Standards

### General Rules
- No emojis in code or commit messages
- Use real tabs (4 width) not spaces
- No commented out code in pull requests
- All functions must be documented
- Keep functions small and single purpose

### C Code
- C11 standard
- No standard library functions
- All code must be freestanding
- Compile with -Wall -Wextra no warnings
- No variable length arrays
- Explicit void for functions with no parameters
- Use kernel Memory_alloc() / Memory_free() NEVER malloc/free

### Assembly Code
- NASM syntax
- 32 bit protected mode
- Comment every non obvious instruction

### Lua Code
- No global variables
- Use local scope always
- Indent with 4 spaces
- no unicode (example: ñ or an emoji, since it gives a syntax error)

## Commit Messages

Use this format:
```
area: short description

Optional longer description of what changed and why.
```

Valid areas:
- kernel
- boot
- gui
- fs
- api
- apps
- build
- docs

## Pull Request Rules

They just don't make my mistakes, or they might, but it's not recommended.

## Things that will get your PR rejected immediately

- Containing emoji
- Code that only works on one operating system
- Unnecessary changes to existing working code
- Large commits that change multiple things
- No description
- Code that prints debug output to terminal
- Commits that only fix whitespace
- Using malloc

## Testing

Always test your changes in QEMU before submitting PR:
```
make run
```

## Project Structure

```
/boot             - x86 Bootloader assembly
/kernel           - Kernel core, memory management, scheduler
/kernel/drivers   - Hardware drivers
/kernel/memory    - Heap memory manager
/filesystem       - Virtual File System (VFS) + RAMFS
/IDT              - Interrupt Descriptor Table
/interrupts       - IRQ handlers
/PIC              - Programmable Interrupt Controller
/timer            - PIT system timer
/IPC              - Inter Process Communication
/process_manager  - Process and thread management
/scheduler        - Multitasking scheduler
/API              - System call API for userspace
/GUI              - Graphic interface engine
/apps             - Builtin system applications
/core             - Userspace system services
/blade            - Blade VM runtime
/shell            - System shell
/terminal         - Text terminal
/assets           - Images, fonts, resources
/IA               - Shellby 'AI assistant'
/installer        - OS Installer
/cpm              - Cocos Package manager
```

If you have questions open an issue first.
