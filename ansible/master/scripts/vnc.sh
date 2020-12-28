#vncserver << EOF
#danscap
#danscap
#N
#EOF


cat << EOF >  ~/.vnc/xstartup

#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
autocutsel -fork
EOF
