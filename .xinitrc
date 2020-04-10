#!/bin/sh
#
# ~/.xinitrc
#
# local xinitrc file, used by all X sessions started by xinit (startx)

. "$HOME/.profile.d/ext.sh";
. "$HOME/.profile.d/run.sh";

audio=;
eval "$(monitor)";
audio-device "$audio";
# X_PDF_VIEWER_OPTS=-r$X_DPI;

xrdb -merge "$HOME/.Xresources";
# xhost +si:localuser:"#$(/usr/bin/id -u)";
xhost +local:;

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

xprop -root \
	-remove _NET_NUMBER_OF_DESKTOPS \
	-remove _NET_DESKTOP_NAMES \
	-remove _NET_CURRENT_DESKTOP;
xsetroot -name "$X_XCLIENT";
xsetroot -cursor_name left_ptr;

keyboard;
pointer;
camera;

\ProfileRcExtGlib;
\ProfileRcExtGtk;
\ProfileRcExtQt;
daylight;

touch "${XDG_RUNTIME_DIR:?}/.dunst_use_critical$DISPLAY";
dunst-restart;

autocutsel -fork -selection PRIMARY -buttonup;
redshift -l "${X_MY_LATITUDE1:?}:${X_MY_LONGITUDE1:?}" &
unclutter -keystroke -idle 1 -root -noevents &

xorg-autolock;
daemonize clipbuffer -rc;

ln -vsrf \
	"${XDG_CONFIG_HOME:?}/sxhkd/us-altgr-intl/sxhkdrc_$X_XCLIENT" \
	"$XDG_CONFIG_HOME/sxhkd/sxhkdrc";
sxhkd-restart;

\ProfileRcExtDbus;

exec "$X_XCLIENT";

# vim: set ft=sh :
