derp
import XMonad 
import XMonad.Config.Xfce
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Data.Ratio
import XMonad.Util.Loggers
import XMonad.Operations	
import System.IO
import XMonad.Layout
import XMonad.Layout.StackTile
import XMonad.Layout.IM
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Reflect
import XMonad.Layout.Combo
import XMonad.Layout.Tabbed
import XMonad.Layout.ResizableTile
import XMonad.Layout.Grid
import XMonad.Layout.Magnifier
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.Circle
import XMonad.Layout.Spiral
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.PerWorkspace
import XMonad.Layout.LayoutHints
import XMonad.Layout.ThreeColumns
import XMonad.Actions.CycleWS
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect

mylayout = avoidStruts (tiled ||| Mirror tiled ||| Grid ||| spiral (1 % 1) ||| Circle  ||| gimp ||| noBorders simpleTabbed ||| noBorders Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 2/3
 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

     gimp = withIM (0.11) (Role "gimp-toolbox") $
             reflectHoriz $
             withIM (0.15) (Role "gimp-dock") Full

main = do



    xmproc <- spawnPipe "/usr/bin/xmobar /home/jiffypop/.xmobarrc"

    xmonad $ xfceConfig

        { workspaces         = ["term", "web", "irc", "rage", "nurps"] 
        , normalBorderColor  = "#000"
        , focusedBorderColor = "#111"
	, manageHook = manageDocks <+> manageHook defaultConfig

        , layoutHook = mylayout
        , 	logHook = dynamicLogWithPP $ xmobarPP

                        { ppOutput = hPutStrLn xmproc

                        , ppTitle = xmobarColor "green" "" . shorten 50

                        }
        

        , modMask = mod4Mask     -- Rebind Mod to the Windows key

        } `additionalKeys`


          



        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")

        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
	, ((mod4Mask .|. shiftMask, xK_Return), spawn $ "xfce4-terminal")
        , ((mod4Mask, xK_n),       spawn "thunar")
        , ((mod4Mask, xK_m),       spawn "gedit")
        , ((mod4Mask, xK_b),       spawn "chromium-browser")
        , ((mod4Mask, xK_p), spawn "scrot")
        , ((mod4Mask, xK_Left),    prevWS )
        , ((mod4Mask, xK_Right),   nextWS )
        , ((mod4Mask .|. shiftMask, xK_c     ), kill) -- %! Close the focused window
        ]


