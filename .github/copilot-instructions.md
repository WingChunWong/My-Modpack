# Workspace Instructions

## 🎯 Project Context
- This is a Minecraft Modpack project ("My Modpack") for Minecraft version **1.21.11** using the **Fabric** modloader.
- The project outputs a Modrinth `.mrpack` format using **ShulkerRDK** (a modular low-code SDK for Minecraft).
- Designed as a lightweight "self-use" pack with primarily client-side optimization and QoL mods (Sodium, Iris, Jade, REI, etc.).

## 🏗️ Architecture & Structure
- `src/mods/`: Stores Modrinth references (`.jar.mrf`) for all mods (avoids large binaries in the repo).
- `src/config/`: Contains mod configurations (`.json`, `.json5`, `.toml`, `.properties`).
- `src/resourcepacks/` & `src/shaderpacks/`: Dedicated to custom textures, UI changes (e.g., CozyUI, CozmoUI) and shaders (e.g., Complementary).
- `shulker/`: Build system and local cache configuration.
  - `shulker/proj.json`: Project configuration (paths, version metadata).
  - `shulker/tasks/`: LVT task definitions for building the pack (`build.lvt`, `build_offline.lvt`).

## 💻 Build & Execution Commands
- **Standard Build**: Execute the build task defined in `shulker/tasks/build.lvt`. 
  - *This flattens mods, copies options and configs, injects Modrinth metadata (`mrp e`), packages the `.mrpack` file via `pkgr zip make`, and drops it in the `build/` folder.*
- **Offline Build**: Use `shulker/tasks/build_offline.lvt` if building without network access.

## 📝 Conventions and Practices
- **Adding Mods**: Do not add raw `.jar` files to the repository. Always use `mrp s` (serialize) commands to generate `.jar.mrf` mod reference structures compatible with ShulkerRDK.
- **Configurations**: Ensure all configuration file edits match their target format strictly (often `.json5` or `.toml` in Fabric).
- **Versioning**: Kept in `shulker/proj.json`. Ensure the `Version` property is bumped according to semantic versioning prior to generating new `.mrpack` releases (you can use `verm smajor`, `verm sminor`, or `verm sfix` via Levitate). Reflexive variables like `%project.ver%` are auto-injected during tasks.

## 🔗 References
- For the full Modlist, Resourcepack list, and Shaderpack list, refer to the [README.md](../README.md).
