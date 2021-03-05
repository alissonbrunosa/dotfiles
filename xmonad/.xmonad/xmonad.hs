import XMonad
import System.Exit
import Data.Ratio -- this makes the '%' operator available (optional)

import XMonad.Actions.UpdatePointer

import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

import Control.Monad (liftM2)
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import Graphics.X11.ExtraTypes.XF86

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch app launcher
    , ((modm,               xK_d     ), spawn "appsmenu")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    , ((modm,               xK_f     ), sendMessage ToggleLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown  )

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown  )

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp    )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster)

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster )

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown   )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp     )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm,               xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm,               xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q                    ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q                    ), spawn "xmonad --recompile; xmonad --restart")
    , ((0                 , xF86XK_AudioMute        ), spawn "volumectl mute")
    , ((0                 , xF86XK_AudioRaiseVolume ), spawn "volumectl plus")
    , ((0                 , xF86XK_AudioLowerVolume ), spawn "volumectl minus")
    , ((0                 , xF86XK_AudioMicMute     ), spawn "pactl set-source-mute 1 toggle")
    , ((0                 , xF86XK_MonBrightnessUp  ), spawn "light -A 5")
    , ((0                 , xF86XK_MonBrightnessDown), spawn "light -U 5")
    , ((0                 , xF86XK_Tools            ), spawn "xscreensaver-command -lock")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- Layouts
gaps = spacingRaw False (Border 3 3 3 3) True (Border 3 3 3 3) True
toggleFullLayout = toggleLayouts Full
myLayouts = avoidStruts $ gaps $ toggleFullLayout $ layoutTall ||| layoutSpiral ||| layoutGrid ||| layoutMirror ||| layoutFull
    where
      layoutTall   = Tall 1 (3/100) (1/2)
      layoutSpiral = spiral (125 % 146)
      layoutGrid   = Grid
      layoutMirror = Mirror (Tall 1 (3/100) (3/5))
      layoutFull   = Full

myManageHook = composeAll
    [ className =? "Alacritty"                        --> viewShift "1"
    , className =? "Firefox Developer Edition"        --> viewShift "2"
    , className =? "Slack"                            --> doShift "3"
    , className =? "Pcmanfm"                          --> viewShift "4"
    , className =? "Spotify"                          --> doShift "8"
    , className =? "TelegramDesktop"                  --> viewShift "9"
    , className =? "Gimp"                             --> doFloat
    , title     =? "Media viewer"                     --> doRectFloat (W.RationalRect 0.05 0.05 0.9 0.9)
    , title     =? "Picture-in-Picture"               --> doIgnore
    , resource  =? "desktop_window"                   --> doIgnore
    , resource  =? "kdesktop"                         --> doIgnore ]
  where viewShift = doF . liftM2 (.) W.greedyView W.shift

-- Autostart
myStartupHooks = do
    spawn "wallpaper"
    spawn "polybar-launch"

main = xmonad $ ewmh $ docks myConfig

myConfig = def
      { terminal            = "alacritty"
      , modMask             = mod4Mask
      , borderWidth         = 1
      , normalBorderColor   = "#d8dee9"
      , focusedBorderColor  = "#88c0d0"
      , layoutHook          = myLayouts
      , keys                = myKeys
      , startupHook         = myStartupHooks <+> ewmhDesktopsStartup
      , manageHook          = manageDocks <+> myManageHook
      , handleEventHook     = docksEventHook <+> ewmhDesktopsEventHook
      , logHook             = ewmhDesktopsLogHook >> updatePointer (0.5, 0.5) (0, 0) }
