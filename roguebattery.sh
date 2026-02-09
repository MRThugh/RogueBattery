#!/data/data/com.termux/files/usr/bin/bash
# RogueBattery - Happy Battery Guardian for Termux
# Bright, cheerful & positive version 🌈
# Crafted by MR.Thugh 😊

# Happy & bright colors
G='\033[1;32m'     # Joyful green
Y='\033[1;33m'     # Shining yellow
C='\033[1;36m'     # Bright cyan
M='\033[1;95m'     # Soft magenta
B='\033[1;94m'     # Sky blue
W='\033[1;97m'     # Bright white
N='\033[0m'

# Friendly & positive icons
HEART="💙"  STAR="✨"  SUN="☀️"  SMILE="😊"  BAT="🔋"  CHARGE="⚡"  COOL="🌤️"  HAPPY="🎉"

# File paths
LOG_FILE="$HOME/storage/downloads/roguebattery_happy_log.txt"
CSV_FILE="$HOME/storage/downloads/roguebattery_happy.csv"
mkdir -p "$(dirname "$LOG_FILE")"

# Settings
CHECK_INTERVAL=180       # Check every 3 minutes
LOW_THRESHOLD=25
CRITICAL_THRESHOLD=15
HIGH_TEMP=42
CRITICAL_TEMP=46

# Check dependencies
check_deps() {
    for cmd in termux-battery-status jq bc termux-notification; do
        command -v "$cmd" >/dev/null 2>&1 || {
            echo -e "${Y}Please install these packages:${N}"
            echo "pkg install termux-api jq bc -y"
            exit 1
        }
    done
}

# Simple and happy banner
show_banner() {
    clear
    echo -e "${C}══════════════════════════════════════${N}"
    echo -e "      ${M}${HEART}  RogueBattery  ${HEART}${N}"
    echo -e "    Taking care of your battery! ${SMILE}"
    echo -e "${C}══════════════════════════════════════${N}\n"
}

# Colorize battery percentage (cheerful)
color_percent() {
    local p=$1
    if [[ $p -ge 70 ]]; then echo -e "${G}$p%${N} ${HAPPY}"
    elif [[ $p -ge 40 ]]; then echo -e "${Y}$p%${N} ${SUN}"
    elif [[ $p -ge 25 ]]; then echo -e "${M}$p%${N} ${STAR}"
    else echo -e "${Y}$p%${N} ${BAT}"
    fi
}

get_battery_info() {
    local json=$(termux-battery-status 2>/dev/null)
    STATUS=$(echo "$json" | jq -r '.status')
    PERCENT=$(echo "$json" | jq -r '.percentage')
    TEMP=$(echo "$json" | jq -r '.temperature' | bc -l | awk '{printf "%.1f", $1}')
    PLUGGED=$(echo "$json" | jq -r '.plugged')
    
    if [[ "$PLUGGED" != "UNPLUGGED" ]]; then
        CHARGE_MSG="${G}${CHARGE} Charging now ${HAPPY}${N}"
    else
        CHARGE_MSG="${B}In use ${SMILE}${N}"
    fi
}

show_status() {
    get_battery_info
    show_banner

    echo -e "  ${BAT} Battery level  : $(color_percent "$PERCENT")"
    echo -e "  $CHARGE_MSG"
    echo -e "  ${C}Temperature     : ${W}${TEMP}°C${N}"

    if (( $(echo "$TEMP > $HIGH_TEMP" | bc -l) )); then
        echo -e "  ${Y}A bit warm... ${STAR} Take it easy for a while ${SMILE}${N}"
    elif (( $(echo "$TEMP > 36" | bc -l) )); then
        echo -e "  ${C}Perfect temperature! ${COOL}${N}"
    else
        echo -e "  ${G}Super cool! ${HAPPY}${N}"
    fi

    echo ""
}

send_happy_alert() {
    local title="$1"
    local msg="$2"
    local prio="${3:-normal}"

    termux-notification \
        --title "$title" \
        --content "$msg" \
        --priority "$prio" \
        --vibrate 400,150,400 \
        --sound > /dev/null 2>&1
}

check_alerts() {
    get_battery_info

    if [[ "$PLUGGED" == "UNPLUGGED" ]]; then
        if [[ $PERCENT -le $CRITICAL_THRESHOLD ]]; then
            send_happy_alert "Hey MR.Thugh! ⚠️" "Battery is only ${PERCENT}% — please charge soon ${HEART}" high
        elif [[ $PERCENT -le $LOW_THRESHOLD ]]; then
            send_happy_alert "Time to charge! 🌟" "${PERCENT}% left... Shall we plug in? ${SMILE}" normal
        fi
    fi

    if (( $(echo "$TEMP > $CRITICAL_TEMP" | bc -l) )); then
        send_happy_alert "Getting hot! 🔥" "Temperature reached ${TEMP}°C — give it a little break ${HEART}" high
    elif (( $(echo "$TEMP > $HIGH_TEMP" | bc -l) )); then
        send_happy_alert "Small warning" "Temperature ${TEMP}°C — take it easy ${STAR}" normal
    fi

    # Logging
    echo "[$(date '+%Y-%m-%d %H:%M')] ${PERCENT}% | ${TEMP}°C | ${PLUGGED}" >> "$LOG_FILE"
    echo "$(date '+%Y-%m-%d %H:%M'),${PERCENT},${TEMP},${PLUGGED}" >> "$CSV_FILE"
}

monitor_loop() {
    echo -e "${G}Happy monitoring started! ${HAPPY}${N}"
    echo "Checks every ${CHECK_INTERVAL} seconds"
    echo "Logs saved to: $LOG_FILE"
    echo "Press Ctrl+C or close the terminal to stop\n"

    while true; do
        check_alerts
        show_status
        sleep $CHECK_INTERVAL
    done
}

main_menu() {
    check_deps
    while true; do
        show_status
        echo -e "${Y}Happy Menu:${N}"
        echo "  1) Start happy monitoring"
        echo "  2) Show current status"
        echo "  3) View recent logs (last 20 lines)"
        echo "  4) Exit"
        echo ""
        read -p "Choose (1-4): " choice

        case $choice in
            1)
                monitor_loop
                ;;
            2)
                show_status
                read -p "Press Enter to continue... "
                ;;
            3)
                clear
                echo -e "${C}Recent logs:${N}"
                tail -n 20 "$LOG_FILE" 2>/dev/null || echo "No logs yet!"
                read -p "Press Enter..."
                ;;
            4)
                echo -e "\n${M}See you later! Love your battery ${HEART}${N}"
                exit 0
                ;;
            *) echo -e "${Y}Please choose a valid number ${SMILE}${N}" ;;
        esac
    done
}

# Start the tool
main_menu
