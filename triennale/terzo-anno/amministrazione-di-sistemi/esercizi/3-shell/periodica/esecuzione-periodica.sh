TMPCRON=$(mktemp)
RIGACRON="* * * * * $HOME/remind.sh $FILEALLARMI"
crontab -l | grep -Fvx "$RIGACRON" > "$TMPCRON"
echo "$RIGACRON" >> "$TMPCRON"
crontab "$TMPCRON"
rm -f "$TMPCRON"
