# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Packwiz-managed Minecraft modpack for Fabric. Packwiz is a command-line tool for creating and managing Minecraft modpacks using TOML metadata files. The modpack targets Minecraft 1.21.11 with Fabric loader 0.18.6.

## Key Commands

### Packwiz CLI
- `packwiz refresh` - Update index.toml after any file changes
- `packwiz modrinth add --project-id <ID> -y` - Add a mod from Modrinth
- `packwiz modrinth export` - Export as .mrpack for Modrinth
- `packwiz curseforge export` - Export as .zip for CurseForge

### Batch Mod Import
- `./add-mods.sh` - Batch import mods from 1.21.11.txt (requires bash environment)

### Build & Release
- CI automatically builds on push to master (build.yml)
- Releases are created on tag push (v*) or manual dispatch (release.yml)
- Build outputs: .mrpack (Modrinth) and .zip (CurseForge)

## Architecture

### File Structure
- `pack.toml` - Main modpack metadata (name, version, Minecraft/Fabric versions)
- `index.toml` - Hash-indexed manifest of all tracked files
- `mods/*.pw.toml` - Mod metadata files (metafile=true means download via packwiz)
- `resourcepacks/*.pw.toml` - Resource pack metadata
- `shaderpacks/*.pw.toml` - Shader pack metadata
- `config/` - Mod configuration files
- `mods/I18nUpdateMod-*.jar` - Local mod file preserved (preserve=true in index)

### Workflow Structure
- `build.yml` - Runs on push, exports both formats, uploads artifacts
- `release.yml` - Runs on tags, creates GitHub release with exported files

### Index Management
When adding/removing mods or config files, always run `packwiz refresh` to update index.toml with correct hashes. The index uses sha256 hash format.

## Modpack Details
- Acceptable game versions: 1.20.1, 1.21.1 (for version compatibility)
- Contains 49 mods, 4 resource packs, 1 shader pack
- Focus: Performance optimization (Sodium, Lithium, C2ME), UI improvements, quality-of-life features