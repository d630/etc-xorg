#!/bin/sh
#
# ~/.xinitrc
#
# local xinitrc file, used by all X sessions started by xinit (startx)

. "$HOME/.profile.d/ext.sh";
. "$HOME/.profile.d/run.sh";

dev=;
if
	/usr/bin/xrandr --listmonitors |
	/bin/grep -F 'HDMI-1';
then
	/usr/bin/xrandr \
		--output HDMI-1 --dpi 96 --auto \
		--output eDP-1 --off;
	X_DPI=96;
	dev=HDMI;
else
	/usr/bin/xrandr \
		--output eDP-1 --dpi 96 --mode 1920x1080 --rate 60.01 \
		--output HDMI-1 --off;
	X_DPI=96;
	dev=PCH;
fi;

export X_DPI;

X_PDF_VIEWER_OPTS=-r$X_DPI;

"${XDG_BIN_HOME:?}/audio-device" "$dev";

/usr/bin/xrdb -merge "$HOME/.Xresources";
# /usr/bin/xhost +si:localuser:"#$(/usr/bin/id -u)";
/usr/bin/xhost +local:;

case $X_XCLIENT in
	(bspwm)
		_JAVA_AWT_WM_NONREPARENTING=1;
		export _JAVA_AWT_WM_NONREPARENTING;;
	(cwm)
		X_XCLIENT=openbsd-cwm;;
	(openbsd-cwm|spectrwm)
		:;;
	(*)
		X_XCLIENT=x-terminal-tabbed;;
esac;

# /usr/bin/numlockx off;
/usr/bin/setxkbmap -model pc105 -layout us \
	-variant altgr-intl -option compose:menu;
/usr/bin/xmodmap "${XDG_CONFIG_HOME:?}/xmodmap/us-altgr-intl-german.rc";
/usr/bin/xinput --disable FJ\ Camera:\ FJ\ Camera;
/usr/bin/xinput --disable SynPS/2\ Synaptics\ TouchPad;
/usr/bin/xkbset m ma 60 10 10 5 2; /usr/bin/xkbset exp =m;
/usr/bin/xprop -root \
	-remove _NET_NUMBER_OF_DESKTOPS \
	-remove _NET_DESKTOP_NAMES \
	-remove _NET_CURRENT_DESKTOP;
/usr/bin/xset -dpms; /usr/bin/xset s off;
/usr/bin/xset b off;
/usr/bin/xset mouse 3 4;
/usr/bin/xset r rate 220 150;
/usr/bin/xsetroot -name "$X_XCLIENT";
/usr/bin/xsetroot -cursor_name left_ptr;

\ProfileRcExtGlib;
\ProfileRcExtGtk;
\ProfileRcExtQt;
"${XDG_BIN_HOME:?}/daylight";

/usr/bin/touch "${XDG_RUNTIME_DIR:?}/.dunst_use_critical$DISPLAY";
"${XDG_BIN_HOME:?}/dunst-restart";

/usr/bin/autocutsel -fork -selection PRIMARY -buttonup;
/usr/bin/redshift -l "${X_MY_LATITUDE1:?}:${X_MY_LONGITUDE1:?}" &
/usr/bin/syndaemon -d -i 0.8;
/usr/bin/unclutter -keystroke -idle 1 -root -noevents &

"$XDG_BIN_HOME/daemonize" "$XDG_BIN_HOME/xorg-autolock";
"$XDG_BIN_HOME/daemonize" "$XDG_BIN_HOME/clipbuffer" -rc;

/bin/ln -vsrf \
	"${XDG_CONFIG_HOME:?}/sxhkd/us-altgr-intl/sxhkdrc_${X_XCLIENT:?}" \
	"$XDG_CONFIG_HOME/sxhkd/sxhkdrc";
"$XDG_BIN_HOME/sxhkd-restart";

\ProfileRcExtDbus;

exec "$X_XCLIENT";

# vim: set ft=sh :
