#!/bin/sh
#
# ~/.xinitrc
#
# local xinitrc file, used by all X sessions started by xinit (startx)

. "$HOME/".profile.d/base.sh;
. "$HOME/".profile.d/ext.sh;
. "$HOME/".profile.d/run.sh;

\ProfileRcExtSxhkd;

\ProfileRcRunXCustoms;

\ProfileRcExtGlib;
\ProfileRcExtGtk;
\ProfileRcExtQt;

\ProfileRcRunDaylight;
\ProfileRcRunXDaemons;

\ProfileRcExtDbus;

exec "$X_XCLIENT";

# vim: set ts=4 sw=4 tw=0 et :
