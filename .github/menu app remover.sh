#!/bin/bash

# Header Information
echo -e "\e[1mProduced by intare_the_mafia, Year: 2025, Date: 4th March\e[0m"
echo -e "\e[3mQuote: 'NEVER FAIL TO TRY'\e[0m"
echo -e "\e[4mGitHub Repo: https://github.com/Lionmafia/ALL-free-LINUX-tools-.git\e[0m"
echo "-----------------------------------"

# Function to display the app listing in green
list_apps() {
  echo -e "\e[32mListing applications...\e[0m"
  mapfile -t DESKTOP_FILES < <(find /usr/share/applications /usr/local/share/applications ~/.local/share/applications -name "*.desktop")
  
  APP_NAMES=()
  APP_FILES=()
  COUNT=1

  for FILE in "${DESKTOP_FILES[@]}"; do
    APP_NAME=$(basename "$FILE" .desktop)
    APP_NAMES+=("$APP_NAME")
    APP_FILES+=("$FILE")
    echo -e "\e[32m[$COUNT] $APP_NAME\e[0m"
    COUNT=$((COUNT + 1))
  done
}

# Ask if the user wants to list apps
while true; do
  echo -e "\nDo you want to list the applications? (y/n)"
  read -r LIST_APPS

  if [[ "$LIST_APPS" =~ ^[Yy]$ ]]; then
    list_apps
    break
  elif [[ "$LIST_APPS" =~ ^[Nn]$ ]]; then
    while true; do
      echo -e "\nDo you want to exit? (y/n)"
      read -r EXIT_CHOICE
      if [[ "$EXIT_CHOICE" =~ ^[Yy]$ ]]; then
        echo "Exiting..."
        exit 0
      elif [[ "$EXIT_CHOICE" =~ ^[Nn]$ ]]; then
        break
      else
        echo "Invalid input. Please enter 'y' or 'n'."
      fi
    done
  else
    echo "Invalid input. Please enter 'y' or 'n'."
  fi
done

# Prompt user to select applications to remove
echo -e "\nSelect applications to remove (comma-separated numbers, e.g., 1,3,5):"
read -r SELECTION

if ! [[ "$SELECTION" =~ ^[0-9,]+$ ]]; then
  echo "Invalid input. Please enter numbers separated by commas."
  exit 1
fi

IFS=',' read -r -a SELECTIONS <<< "$SELECTION"

for INDEX in "${SELECTIONS[@]}"; do
  if [[ $INDEX =~ ^[0-9]+$ ]]; then
    INDEX=$((INDEX - 1))

    if [[ $INDEX -ge 0 && $INDEX -lt ${#APP_NAMES[@]} ]]; then
      APP_NAME="${APP_NAMES[$INDEX]}"
      APP_FILE="${APP_FILES[$INDEX]}"

      EXECUTABLE=$(grep -Po '^Exec=\K[^ ]+' "$APP_FILE" | head -n 1)

      if [[ -n "$EXECUTABLE" ]]; then
        PACKAGE_NAME=$(pacman -Qo "$(which "$EXECUTABLE" 2>/dev/null)" 2>/dev/null | awk '{print $5}' | head -n 1)

        if [[ -n "$PACKAGE_NAME" ]]; then
          echo "Removing application: $APP_NAME (package: $PACKAGE_NAME)"
          sudo pacman -Rs "$PACKAGE_NAME"
        else
          echo "Could not determine package name for $APP_NAME. Removing .desktop file only."
        fi
      else
        echo "No executable found in .desktop file for $APP_NAME. Removing .desktop file only."
      fi

      echo "Removing application from menu: $APP_NAME"
      rm -f "$APP_FILE"
    else
      echo "Invalid selection: $((INDEX + 1))"
    fi
  else
    echo "Skipping invalid input: $INDEX"
  fi
done

# Refresh the desktop database
echo "Refreshing the application menu..."
update-desktop-database ~/.local/share/applications
update-desktop-database /usr/share/applications

echo "Done."
