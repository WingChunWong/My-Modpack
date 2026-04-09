---
name: shulker-build-system
description: Instructions for understanding, maintaining, and debugging the ShulkerRDK build system and Levitate Task scripts (.lvt files).
---

# Skill: shulker-build-system

## Overview
This skill provides instructions for understanding, maintaining, and debugging the ShulkerRDK build system, which uses Levitate Task scripts (`.lvt` files). This modular, low-code SDK automates the CI/packaging pipeline for Minecraft Modrinth `.mrpack` files.

## Context & Components
- **Configuration**: `shulker/proj.json` holds the project metadata such as `ProjectName`, `Version`, `RootPath` (`%project.src%`), and `OutPath` (`%project.output%`).
- **Built-in Variables**:
  - `%project.name%`: Project name
  - `%project.ver%`: Semantic version
  - `%project.src%`: Source directory
  - `%project.output%`: Build output directory
  - `%project.cache%`: Implicit temporary cache folder (aliases to `%project.src%` if not defined, but typically a local cache)
- **Tasks**: `shulker/tasks/*.lvt` files form the pipeline. 

## Levitate (`.lvt`) Syntax & Commands
When modifying `.lvt` tasks, adhere to the established ShulkerRDK Levitate syntax:
- **`import <module>`**: Loads extensions (e.g., `shulker.modrinth`, `shulker.magick`).
- **`copy <src> <dest> [overwrite] [ignoreRegex]`**: Copys files or directories. Boolean arguments must be lowercase `true`/`false`.
- **`delete <path> [ignoreRegex]`**: Deletes a target directory or file.
- **`flat <src> <dest> [overwrite] [ignoreRegex]`**: Flattens all nested files from the source directory directly into the destination root. Ideal for collating `.jar.mrf` mod files.
- **`ifr @<key> <new_value> <file>`**: In-file substitute to replace placeholders without regex (e.g., `ifr @version "%project.ver%" pack.mcmeta`).
- **`pkgr zip make <src_dir> <dest_file>`**: Create zip archives.
- **`verm <smajor|sminor|sfix|set|get>`**: Manipulates semantic version strings.
- **`sh <cmd>`**: Executes shell commands (e.g., `sh powershell /c build.ps1`).
- **`run <file.lvt> [new]`**: Call sub-tasks.

### Modrinth Extension (`shulker.modrinth`)
- **`mrp s <input> [<destination>]`**: Serialize. Hashes Mod `.jar` files and fetches metadata from Modrinth, creating lightweight `.mrf` (Mod Reference Format) records.
- **`mrp r <input>`**: Restore. Resolves `.mrf` files back into fully downloaded `.jar` files.
- **`mrp e <dir> <index.json> [destroySource]`**: Export. Reads `shulker/mrpack.template.json`, embeds local cache definitions, and drops a `.mrpack` index payload.

## Workflow: Updating Build Tasks
1. **Analyze Needs**: Determine if the new feature requires copying new resource folders (`copy`), converting imagery (`psdcvt` via `shulker.magick`), or adjusting Modrinth outputs.
2. **Modify `.lvt`**: Apply specific commands to the target task file (e.g., `build.lvt`).
3. **Variable Usage**: Use project variables (e.g., `%project.cache%`) rather than hardcoding. Surround interpolations with spaces in quotes: `"%project.output%%project.name%_%project.ver%.mrpack"`.
4. **Cleanup**: Always ensure temporary files and caches are cleaned up at the end of the script using `delete "%project.cache%"`.

## Workflow: Debugging Build Issues
1. **Check `shulker/proj.json`**: Ensure base valid JSON and required properties exist.
2. **Boolean Casing**: Review `.lvt` arguments. ShulkerRDK specifically requires `true`/`false` (lowercase).
3. **Paths Existence**: Verify referenced standard source directories (like `src/mods/`, `src/config/`) exist before commands refer to them.
4. **Missing MRF issues**: If offline builds fail, double-check that `mrp s` was properly executed upstream to sync new mod additions.
