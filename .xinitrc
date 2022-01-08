#!/bin/sh
#
# ~/.xinitrc
#
# local xinitrc file, used by all X sessions started by xinit (startx)

. "$HOME/.profile.d/ext.sh"
. "$HOME/.profile.d/run.sh"

audio=
eval "$(exec -- reconfigure-monitor)"
command -- reconfigure-audio "$audio"
# X_PDF_VIEWER_OPTS=-r$X_DPI;

command -- xrdb -merge "$HOME/.Xresources"
# xhost +si:localuser:"#$(/usr/bin/id -u)";
command -- xhost +local:

case $X_XCLIENT in
    bspwm)
        XDG_CURRENT_DESKTOP=bspwm
        GDMSESSION=bspwm
        _JAVA_AWT_WM_NONREPARENTING=1
        export _JAVA_AWT_WM_NONREPARENTING XDG_CURRENT_DESKTOP GDMSESSION
        ;;
    cwm)
        X_XCLIENT=openbsd-cwm
        ;;
    openbsd-cwm | spectrwm)
        :
        ;;
    *)
        X_XCLIENT=x-terminal-tabbed
        ;;
esac

command -- xprop -root \
    -remove _NET_NUMBER_OF_DESKTOPS \
    -remove _NET_DESKTOP_NAMES \
    -remove _NET_CURRENT_DESKTOP
command -- xsetroot -name "$X_XCLIENT"
command -- xsetroot -cursor_name left_ptr

command -- reconfigure-keyboard
command -- reconfigure-pointer
command -- reconfigure-camera

\ProfileRcExtGlib
\ProfileRcExtGtk
\ProfileRcExtQt
command -- daylight

command -- touch -- "${XDG_RUNTIME_DIR:?}/.dunst_use_critical$DISPLAY"
command -- restart-dunst

command -- autocutsel -fork -selection PRIMARY -buttonup
command -- redshift -l "${X_MY_LATITUDE1:?}:${X_MY_LONGITUDE1:?}" &
command -- unclutter -keystroke -idle 3 -root -noevents &

command -- xorg-autolock
command -- daemonize clipbuffer -rc

command -- ln -vsrf -- \
    "${XDG_CONFIG_HOME:?}/sxhkd/us-altgr-intl/sxhkdrc_$X_XCLIENT" \
    "$XDG_CONFIG_HOME/sxhkd/sxhkdrc"
command -- restart-sxhkd

\ProfileRcExtDbus

exec -- "$X_XCLIENT"

# vim: set ft=sh :
