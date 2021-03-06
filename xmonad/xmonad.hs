-- original: /usr/doc/xmonad-0.15/xmonad.hs
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import System.Exit
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map as M

myTerminal = "gnome-terminal"

-- focus with the mouse
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- clicking on a window to focus also performs a click
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- window border width
myBorderWidth = 2

-- window border colors
myNormalBorderColor = "#9e7fb2"
myFocusedBorderColor = "#c3ff97"

-- mod key: left alt
myModMask = mod1Mask

-- workspace tags
myWorkspaces = ["#","2","3","4","5","6","7","8","9"]

-- keybindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  -- launch terminal
  [ ((modm, xK_Return), spawn $ XMonad.terminal conf)

  -- launch dmenu
  , ((modm, xK_BackSpace), spawn $ "dmenu_run")

  -- screenshots
  -- select area
  , ((modm, xK_s), spawn $ "sleep 0.2; scrot -s /tmp/screenshot-$(date +%F_%T).png -e 'xclip -selection c -t image/png < $f'")

  -- full screen
  , ((modm .|. shiftMask, xK_s), spawn $ "scrot /tmp/screenshot-$(date +%F_%T).png -e 'xclip -selection c -t image/png < $f'")

  -- close focused window
  , ((modm .|. shiftMask, xK_c), kill)

  -- Rotate through the available layout algorithms
  , ((modm,               xK_space ), sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default
  , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

  -- Move focus to the next window
  , ((modm,               xK_Tab   ), windows W.focusDown)

  -- Move focus to the previous window
  , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp  )

  -- Shrink the master area
  , ((modm,               xK_h     ), sendMessage Shrink)

  -- Expand the master area
  , ((modm,               xK_l     ), sendMessage Expand)

  -- Swap the focused window with the next window
  , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

  -- Swap the focused window with the previous window
  , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

  -- Quit xmonad
  , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

  -- Restart xmonad
  , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

  ]

  ++
  --
  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  --
  [
    ((m .|. modm, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ]

  ++

  --
  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  -- This is to switch between monitors!
  [
    ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_n, xK_m, xK_r] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ]

main = do
  xmproc <- spawnPipe "/home/maldad/.cabal/bin/xmobar"
  xmonad $ docks $ defaults {
      manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    , logHook = dynamicLogWithPP $ xmobarPP {
        ppOutput = hPutStrLn xmproc
      , ppOrder = \(ws:l:t:_) -> [ws]
    }
  }

defaults = def
  { terminal = myTerminal
  , borderWidth = myBorderWidth
  , normalBorderColor = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  , focusFollowsMouse = myFocusFollowsMouse
  , clickJustFocuses = myClickJustFocuses
  , keys = myKeys
  } `additionalKeysP`
  [ ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ("<XF86AudioPlay>", spawn "mpc toggle")
  , ("<XF86AudioNext>", spawn "mpc next")
  , ("<XF86AudioPrev>", spawn "mpc prev")
  , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
  , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
  ]
