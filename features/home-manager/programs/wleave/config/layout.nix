{config}: ''
  {
    "buttons": [
      {
        "label": "lock",
        "action": "loginctl lock-session",
        "text": "Lock Screen?",
        "keybind": "l"
      },
      {
        "label": "logout",
        "action": "loginctl terminate-user $USER",
        "text": "Logout?",
        "keybind": "e"
      },
      {
        "label": "shutdown",
        "action": "poweroff",
        "text": "Shutdown?",
        "keybind": "s"
      },
      {
        "label": "reboot",
        "action": "reboot",
        "text": "Reboot?",
        "keybind": "r"
      }
    ]
  }
''
