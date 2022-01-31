import Xmobar

config :: Config
config = defaultConfig { font = "FiraCode Nerd Font Mono-11"
                       , bgColor = "#333438"
                       --, bgColor = "#FF0038"
                       , position = Top
                       , commands = [ Run $ Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
                                    , Run $ Network "enp7s0" ["-L","0","-H","32",
                                                             "--normal","green","--high","red"] 10
                                    , Run $ Network "wlp8s0" ["-L","0","-H","32",
                                                             "--normal","green","--high","red"] 10
                                    , Run $ Cpu ["-L","3","-H","50",
                                                  "--normal","green","--high","red"] 10
                                    , Run $ Memory ["-t","Mem: <usedratio>%"] 10
                                    , Run $ Swap [] 10
                                    , Run $ Com "uname" ["-s","-r"] "" 36000
                                    , Run   XMonadLog
                                    ]
                       , sepChar = "%"
                       , alignSep = "}{"
                       , template = "%XMonadLog% }{ %memory% * %swap% | %enp7s0% - %wlp8s0% | %date% | %uname%"
                       }

main :: IO ()
main = xmobar config
