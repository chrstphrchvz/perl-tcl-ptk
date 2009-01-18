Experimental Mods to Tcl-Tk for better perl/tk compatibility

Tcl-Tk-jcmods.01.tar.gz contains some changes against the release perl package Tcl-Tk-0.97. 
The objective of these changes it to make Tcl-Tk scripts be more compatible with perl/tk syntax.

Features:

* Pure perl megawidgets work, using the same syntax as perl/tk.
  See the new test case t/slideMegaWidget.t for a simple example.

* All the perl/tk widget demos work with minimal changes,
  typically by just changing the "Use Tk;" to "Use Tcl::Tk (qw/ :perlTk /)" at the top of the file.

* Built-in local drag-drop support, compatible with perl/tk drag-drop coding syntax.


Design Approach:

* These modifications borrow much code from perl/tk. Much of the Tcl::Tk changes
  were made by stepping thru the perl/tk widget demos, and making modifications
  to get the demos to work with minimal changes. When a compatibility problem was found,
  it typically was fixed by using the perl/tk approach (borrowing code as needed). 

* For a lot features, we are essentially using the perl/tk perl-code as-is,
  and using Tcl::Tk like perl/tk uses it's modified Tk c-code back-end. 
  One Example of this is the mega-widget implementation.

* Tcl::Tk widget objects have been changed to be a blessed hash-ref,
  rather than a blessed array-ref, for compatibility with perl/tk.

Installation:

* Requires a working Tcl installation (with tk). Version 8.5 is preferred. Additional 
  packages Tix and BWidget are helpful, but not required.

* Requires the perl Tcl pacakge. (Just like the un-modified Tcl-Tk package).

* To Install, use the standard perl install procedure:
   make
   make test (lots of new test cases have been added)
   
* Note the omission of "make install" above. You probably don't
  want to install this package, since it is experimental, and not
  officially released. You can run the widget demos using the files
  in the local directory by using "-Mblib" option to run the scripts.
  For example, to run the megawidget test case, type "perl -Mblib -w t/slideMegaWidget.t".
  To run the widget demos, see below.

Running the Widget Demos:

* The widget demos all work. They have been converted from the
  perl/tk widget demos, with minimal changes. 

* To run the demos without having to install the package, 
  type "perl -Mblib -w widgetTclTk" on the command line.

Testing Notes:

* These modifications have been tested on the following platforms:
  - WinXP using perl 5.8.4, Activestate Tcl/Tk 8.5.2 with Tix 
    installed using teacup, Tcl.pm 0.95, Tcl-Tk 0.97.
  - Linux (Ubuntu 8.04) using perl 5.8.8, Tcl/Tk 8.5.0 
    with Tix installed, Tcl.pm 0.95, Tcl-Tk 0.97.





