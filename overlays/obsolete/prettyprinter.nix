{ pkgs, haskellLib }:
with haskellLib;

(hself: hsuper: {
#  prettyprinter = hsuper.callHackageDirect { 
#    pkg = "prettyprinter";
#    ver = "1.7.0";
#    sha256 = "17byy08brwcsl5rqdhibq3pcpgx085shizb2ap6s4xy3izdia3cc"; } {};
#
#  dhall = dontCheck (hsuper.callHackageDirect {
#    pkg = "dhall";
#    ver = "1.35.0";
#    sha256 = "0cadfh6b1i18kjqa6aaqm0an3qfzzvpyswdr7gq0b2fl1s740bkn"; } {});

})
