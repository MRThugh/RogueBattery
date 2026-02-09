# RogueBattery 🌈🔋

**A cheerful, colorful, and super-friendly battery guardian made just for Termux!**

RogueBattery brings joy to your terminal by showing your phone's battery status with bright colors, cute emojis, helpful alerts, temperature warnings, and automatic logging — all wrapped in a positive and happy vibe 😊💙

Created and maintained by **[MRThugh](https://github.com/MRThugh)**

Perfect for:
- People who love colorful terminals
- Those who want gentle reminders to charge or cool down their phone
- Termux users who want a lightweight battery watcher

## ✨ Features

- Bright & joyful color scheme (green, yellow, cyan, magenta, sky blue)
- Friendly emojis and positive messages everywhere
- Shows battery percentage with fun indicators (🎉☀️✨😊)
- Displays charging status
- Monitors temperature with gentle warnings
- Sends Termux notifications (with vibration & sound)
- Saves history to log file + CSV (easy to open in spreadsheet or Google Sheets)
- Simple interactive menu
- Runs continuously or one-time checks

## 📸 Example Output

When you run it, the terminal looks something like this:

```
══════════════════════════════════════
      💙  RogueBattery  💙
    Taking care of your battery! 😊
══════════════════════════════════════

  🔋 Battery level  : 92% 🎉
  ⚡ Charging now 🎉
  Temperature     : 31.8°C

  Super cool! 🎉
```

(You can add your own screenshots later by uploading images to the repo and linking them here.)

## 🚀 Installation

### 1. Prerequisites (run once)

```bash
# Update Termux packages
pkg update -y && pkg upgrade -y

# Install required tools
pkg install termux-api jq bc -y
```

**Very important:**  
Download and install the **Termux:API** companion app:
- From F-Droid (recommended) → https://f-droid.org/packages/com.termux.api/
- Or from Google Play Store

Then open Termux:API app and **grant all requested permissions** (Battery stats, Notifications, etc.)

### 2. Clone the repo

```bash
git clone https://github.com/MRThugh/RogueBattery.git
cd RogueBattery
```

### 3. Run it!

```bash
chmod +x roguebattery.sh
./roguebattery.sh
```

Enjoy your happy battery friend! 😊

## 🎮 How to Use – Menu Guide

After running, you'll see this colorful menu:

```
Happy Menu:
  1) Start happy monitoring          → Continuous check + alerts
  2) Show current status             → Quick look
  3) View recent logs (last 20 lines)→ See history
  4) Exit
```

- **Option 1**: Starts monitoring loop (checks every 3 minutes by default)  
  - Shows updated status each time  
  - Sends notifications when battery low or temperature high  
  - Press **Ctrl+C** to stop

- **Option 2**: Instant status check (no loop)

- **Option 3**: Displays last 20 lines from the log file

Logs are automatically saved to (make sure you ran `termux-setup-storage` before if needed):

- Text log: `~/storage/downloads/roguebattery_happy_log.txt`
- CSV log: `~/storage/downloads/roguebattery_happy.csv` (great for Excel/Google Sheets)

## ⚙️ Customize It (super easy)

Edit `roguebattery.sh` with nano/vi and change these variables near the top:

```bash
CHECK_INTERVAL=180       # seconds → 60 = 1 min, 300 = 5 min, etc.
LOW_THRESHOLD=25         # Warn below 25%
CRITICAL_THRESHOLD=15    # Critical alert below 15%
HIGH_TEMP=42             # Warm warning above 42°C
CRITICAL_TEMP=46         # Hot alert above 46°C
```

You can also tweak colors, emojis, messages, or even add new features!

## 🛠️ Troubleshooting

| Problem                              | Solution                                                                 |
|--------------------------------------|--------------------------------------------------------------------------|
| termux-battery-status: command not found | Install `termux-api` package + Termux:API app + grant permissions       |
| No temperature shown                 | Some Android versions/devices restrict temp access — percentage still works |
| No notifications                     | Check Termux settings → Notifications → Allow, and Termux:API permissions |
| Storage path not found               | Run `termux-setup-storage` once to create ~/storage/downloads           |

## 🌟 Contributing

Love it? Want to make it even happier?  
Feel free to open issues or pull requests!

Fun ideas to add:
- ASCII battery bar (e.g. [█████     ] 50%)
- Different themes (dark mode, pastel, etc.)
- Auto background run with `termux-boot`
- Battery health percentage (if API supports)
- More cute alert sounds/messages

## 📜 License

MIT License — free to use, modify, share, and enjoy!

Made with joy by **[MRThugh](https://github.com/MRThugh)** 😊💙

Happy monitoring — and keep your battery smiling! 🔋✨
