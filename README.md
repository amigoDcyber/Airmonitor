# Application Removal Tool

## Produced by ÂMÎĞo.Đ.ĈŶƁeŘ  
**Year:** 2025  
**Date:** 4th March  
**Quote:** "NEVER FAIL TO TRY"

## Description
This Bash script provides an interactive way to list and remove applications from an Arch Linux system. It ensures that only selected applications are removed while keeping dependencies intact.

## Features
- Lists installed applications in **green** text.
- Asks the user whether they want to list applications.
- Provides an option to exit the script if the user does not want to list apps.
- Allows users to select multiple applications for removal.
- Identifies the package associated with an application and removes it using `pacman -Rs`.
- Removes `.desktop` entries from the application menu.
- Updates the application menu after modifications.
- Includes a **GitHub repository** for reference.

## Usage
1. **Run the script:**
   ```bash
   ./script.sh
   ```
2. The script will ask if you want to list applications.
   - If "y", installed applications are displayed in **green text**.
   - If "n", you can either **exit** or **restart** the question.
3. Enter the numbers of the applications you want to remove (comma-separated).
4. The script identifies the package associated with each selected app and removes it.
5. The script also deletes the `.desktop` file from the application menu.
6. Finally, the application menu database is updated.

## Prerequisites
- **Arch Linux** (or an Arch-based distribution)
- `pacman` (for package management)
- `update-desktop-database` (for refreshing the application menu)

## Repository
Find the script on GitHub: [Lionmafia/ALL-free-LINUX-tools](https://github.com/amigo-d-cyber/ALL-free-LINUX-tools-.git)

## License
This script is open-source and can be freely modified and distributed.

## Disclaimer
Use this script at your own risk. Ensure that you **review** the selected applications before removal to avoid accidentally uninstalling essential packages.

