!SLIDE[bg=_images/backgrounds/white_bg.png]
# Hey Check out Code

    @@@ shell
    curl -sL https://ibm.biz/idt-installer | bash
    [main] --==[ IBM Cloud Developer Tools for Linux/MacOS - Installer, v1.2.3 ]==--
    [install] Starting Update...
    [install_deps] Checking for and updating 'apt-get' support on Linux


!SLIDE[bg=_images/backgrounds/white_bg.png]
# Hey Check out Console output


    @@@ Console
    curl -sL https://ibm.biz/idt-installer | bash
    [main] --==[ IBM Cloud Developer Tools for Linux/MacOS - Installer, v1.2.3 ]==--
    [install] Starting Update...
    [install_deps] Checking for and updating 'apt-get' support on Linux


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Install the IBM Developer Toolkit

    $ curl -sL https://ibm.biz/idt-installer | bash
    [main] --==[ IBM Cloud Developer Tools for Linux/MacOS - Installer, v1.2.3 ]==--
    [install] Starting Update...
    [install_deps] Checking for and updating 'apt-get' support on Linux
    ...
    ...


~~~SECTION:notes~~~

https://console.bluemix.net/docs/cli/idt/setting_up_idt.html#add-cli
https://console.bluemix.net/docs/cli/reference/bluemix_cli/get_started.html#getting-started


https://clis.ng.bluemix.net/download/bluemix-cli/latest/osx
https://clis.ng.bluemix.net/download/bluemix-cli/latest/win64
https://clis.ng.bluemix.net/download/bluemix-cli/latest/linux64

~~~ENDSECTION~~~


!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Validate installation

    $ which bx
    /home/nibz/local/bin/bx
    $ which kubectl
    /usr/bin/kubectl


