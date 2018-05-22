!SLIDE[bg=_images/backgrounds/white_bg.png]

# Code samples!

~~~SECTION:notes~~~

This is a presenter note example.

~~~ENDSECTION~~~

	@@@ javascript
	function setupPreso() {
	  if (preso_started)
	  {
	     alert("already started")
	     return
	  }
	  preso_started = true

	  loadSlides()
	  doDebugStuff()

	  document.onkeydown = keyDown
	}

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Terminal replay!

	$ git commit -am 'incremental bullet points working'
	[master ac5fd8a] incremental bullet points working
	 2 files changed, 32 insertions(+), 5 deletions(-)

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Sequential Terminal Replay!

	$ git commit -am 'incremental bullet points working'
	[bmaster ac5fd8a] incremental bullet points working
	 2 files changed, 32 insertions(+), 5 deletions(-)
	
	$ git commit -am 'incremental bullet points working'
	[cmaster ac5fd8a] incremental bullet points working
	 2 files changed, 32 insertions(+), 5 deletions(-)

!SLIDE[bg=_images/backgrounds/white_bg.png] commandline incremental

# Even More Terminal Replay!

    # root command
    some output

    $ command over \
      several lines
    some more output
    over several lines

    $ no output command with \( backslashes \)
    $ command
    output with
    a

    blank line
