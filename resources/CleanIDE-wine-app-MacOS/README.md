# CleanIDE

The Clean IDE is currently only available for Windows. However using the wine tool
you can run the CleanIDE on both Linux and MacOS.

## Run CleanIDE.exe on Linux or MacOS with wine

Just do the following to run the CleanIDE.exe with wine on

```bash

CLEAN_URL="https://ftp.cs.ru.nl/Clean/Clean31/windows/Clean_3.1_64.zip"
curl -L -o "clean.zip" "$CLEAN_URL"
unzip "clean.zip"
wine "Clean 3.1/CleanIDE.exe"
#    or with a project file
wine "Clean 3.1/CleanIDE.exe" "somedir\myproject.prj"
```

## Create MacOS app for Windows CleanIDE GUI app

Requirements:

- wine \
  on MacOS you an easily install wine using homebrew with the command:

  ```bash
  brew install wine-stable
  ```

# Create MacOS app for Windows CleanIDE GUI app running with wine on Linux or MacOS

Using the Platypus app you can easily create a MacOS application from a script. We
use it to create a MacOS application
[`CleanIDE.app`](https://github.com/harcokuppens/clean-classic-helloworld/releases/download/macOS_application/CleanIDE.app.zip)
for the Windows CleanIDE.exe which runs in the background with wine.

This App can be easily created with the command:

```bash
./create-app.bash
# the CleanIDE.app/ app folder is created in current folder
```

An already build version of the
[`CleanIDE.app`](https://github.com/harcokuppens/clean-classic-helloworld/releases/download/macOS_application/CleanIDE.app.zip)
can be downloaded
[here](https://github.com/harcokuppens/clean-classic-helloworld/releases/download/macOS_application/CleanIDE.app.zip).

The `CleanIDE.app` supports:

- open `.prj`,`dcl`, and `.icl` files fron the Finder
- drag & drop of `.prj`,`dcl`, and `.icl` files

Limitations:

- The binaries build are Windows binaries, and must als be run using wine. However
  you can run the build binaries within the Clean app, or when you install the
  commandline version of Clean for MacOS you can build binaries which work directly
  on MacOS.
- the MacOS application always launches a new Clean IDE instance.\
  Explanation:

        On Windows

            - click on "FILE.icl" file in explorer : opens in existing Clean IDE instance
              note: this is the same as running in terminal the command:

                          start FILE.icl
                              or
                          start CleanIDE.exe file.icl

                     The latter when the CleanIDE.exe is not configured
                     as the default application for ".icl" files.

            - in windows terminal: run the command

                    cleanIDE.exe FILE.icl

              this always opens a new Clean IDE instance.

        On MacOS using wine: start is broken:

            In real Windows, the "start" (and shell file associations) can invoke an existing program window using advanced
            messaging like DDE (Dynamic Data Exchange) or COM.
            CleanIDE (like many Windows apps) probably uses DDE or similar to receive new files when already open.

            In Wine, those mechanisms are either partially implemented or not implemented at all, so every

                start CleanIDE.exe FILE.icl

            ends up launching a new process, because there's no way for Wine to "tell" CleanIDE
            to reuse the existing window.

Requirements:

- Platypus app from https://sveinbjorn.org/platypus \
   After installing Platypus app install the platypus command via the App by pressing
  an install button at:

  ```
  menu "Platypus -> Settings -> click "Install" button
  ```

- wine \
  on MacOS you an easily install wine using homebrew with the command:

  ```bash
  brew install wine-stable
  ```
